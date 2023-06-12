import 'dart:convert';
import 'dart:io';
import 'package:cellkraft_crud_firebase/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import '../shared_preferences/shared_preferences.dart';

class ProductServices{
  final String urlDB = "cellkraft-default-rtdb.firebaseio.com";
  final prefs = SharedUserPreferences();

  Future<bool> createProduct(ProductModel product) async{
    bool result = false;
    final Uri uri = Uri.https(urlDB, "productos.json", {'auth' : prefs.token});
    final restAPIResponse = await http.post(uri, body: productModelToJson(product));
    final decodeResponse = json.decode(restAPIResponse.body);
    print(decodeResponse);
    result = true;
    return result;
  }

  Future<List<ProductModel>> loadProducts() async{
    final List<ProductModel> productList = [];

    final Uri uri = Uri.https(urlDB, "productos.json", {'auth' : prefs.token});
    final restAPIResponse = await http.get(uri);
    final Map<String, dynamic> productMap = jsonDecode(restAPIResponse.body);

    print(productMap);

    if(productMap == null) return [];

    productMap.forEach((key, value) {
        print(value);
        final product = ProductModel.fromJson(value);
        product.id = key;
        productList.add(product);
       }
    );
    print(productList);

    return productList;
  }

    Future<bool> deleteProduct(String? id) async{
      bool result = false;
      final Uri uri = Uri.https(urlDB, "productos/$id.json", {'auth' : prefs.token});
      final restAPIResponse = await http.delete(uri);
      final decodeResponse = json.decode(restAPIResponse.body);

      print(decodeResponse);
      result = true;

      return result;
    }

  Future<bool> updateProduct(ProductModel product) async{
    bool result = false;
    final Uri uri = Uri.https(urlDB, "productos/${product.id}.json", {'auth' : prefs.token});
    final restAPIResponse = await http.put(uri, body: productModelToJson(product));
    final decodeResponse = json.decode(restAPIResponse.body);

    print(decodeResponse);
    result = true;

    return result;
  }

  Future<String> uploadImage(File? image) async{
    String urlFoto = "";
    final urlCloudinary = Uri.parse("https://api.cloudinary.com/v1_1/imagenesproyectoaaron/image/upload?upload_preset=cyxw7y6c");
    final imageUploadRequest = http.MultipartRequest('POST', urlCloudinary);

    /* Al hacer el split obtengo una lista en el que el 1er elemento es el tipo de multimedia
     y el 2do elemento es el tipo de archivo */
    final mimeType = mime(image?.path)!.split("/"); // Ejemplo: image/jpg

    //preparo el archivo a enviar en mi solicitud de tipo POST
    final fileToLoad = await http.MultipartFile.fromPath(
        'file',
        image!.path,
        contentType: MediaType(mimeType[0], mimeType[1])
    );

    //Adjunto el archivo de la solicitud
    imageUploadRequest.files.add(fileToLoad);

    //Envio la solicitud para cargar la imagen a cloudinary
    final imageUploadResponse = await imageUploadRequest.send();

    if(imageUploadResponse.statusCode != 200 & 201){
      print(imageUploadResponse.statusCode);
    }
    final dataResponse = json.decode(await imageUploadResponse.stream.bytesToString());
    print(dataResponse);

    urlFoto = dataResponse['secure_url'];

    return urlFoto;
  }
}

