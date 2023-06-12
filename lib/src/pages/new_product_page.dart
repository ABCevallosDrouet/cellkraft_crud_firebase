import 'dart:io';
import 'package:cellkraft_crud_firebase/src/models/product_model.dart';
import 'package:cellkraft_crud_firebase/src/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:cellkraft_crud_firebase/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class NewProductPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProductPageState();
}

class ProductPageState extends State<NewProductPage> {
  final formKey = GlobalKey<FormState>();
  ProductModel product = ProductModel();
  ProductServices productServices = ProductServices();
  bool saving = false;
  File? imageFile;
  final imagePicker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    ProductModel? modifyProduct = ModalRoute.of(context)?.settings.arguments as ProductModel?;

    if(modifyProduct != null){
      product = modifyProduct;
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(180, 0, 150, 0.9),
              Color.fromRGBO(0, 160, 150, 0.9)
            ]
          ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.black38,
          title: const Text("Nuevo producto"),
          actions: [
            IconButton(
                onPressed: selectImage,
                icon: const Icon(Icons.photo_size_select_actual),
            ),
            IconButton(
                onPressed: takePhoto,
                icon: const Icon(Icons.camera_alt),
            ),
          ]
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  showPhoto(),
                  createName(),
                  createPrice(),
                  createAvailable(),
                  createButton(),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget showPhoto() {
    if (product.fotoUrl != null && product.fotoUrl != "") {
      return FadeInImage(
          placeholder: const AssetImage("assets/loading.gif"),
          image: NetworkImage(product.fotoUrl!),
          height: 500,
          width: double.infinity,
          fit: BoxFit.contain
      );
    }
    else {
      if (imageFile != null) {
        return Image.file(
          imageFile!,
          height: 500,
          fit: BoxFit.contain,
        );
      }
      return Image.asset('assets/no_available_image.png', height: 400,);
    }
  }

  Future processImage(ImageSource imageSource) async {
    final selectImage = await imagePicker.pickImage(
        source: imageSource
    );

    //
    if(selectImage != null){
      product.fotoUrl = null;
    }

    setState(() => imageFile = File(selectImage!.path));
  }

  Future selectImage() async => processImage(ImageSource.gallery);

  Future takePhoto() async => processImage(ImageSource.camera);


  Widget createName(){
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: Colors.white),
    decoration: const InputDecoration(
      labelText: "Producto",
      labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (value){
        if(value!.length < 3) {
          return "Ingrese el nombre del producto correctamente";
        }
      },
      onSaved: (value) => product.titulo = value,
    );
  }

  Widget createPrice(){
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: "Precio",
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (value){
        if(utils.isNumeric(value.toString())){
          return null;
        }
        else{
          return "Por favor solo ingrese numeros";
        }
      },
      onSaved: (value) => product.valor = double.parse(value!),
    );
  }

  Widget createAvailable(){
    return SwitchListTile(
        value: product.disponible,
        title: const Text("Producto disponible", style: TextStyle(color: Colors.white)
        ),
        activeColor: Colors.white,
        onChanged: (value) => setState(() => product.disponible = value)
    );
  }

  Widget createButton(){
    return ElevatedButton.icon(
        onPressed: saving ? null : submit,
        icon: const Icon(Icons.save_outlined),
        label: const Text("Guardar")
    );
  }

  void submit() async{
    //Retorna true si el formulario es valido
    if(formKey.currentState?.validate() == false) return;
    setState(() => saving = true);
    //Se guardan los datos ingresados en el objeto product y se mapean
    formKey.currentState?.save();

    print(product.titulo);
    print(product.valor);

    if(imageFile != null){
      product.fotoUrl = await productServices.uploadImage(imageFile);
    }

    if(product.id == null){
    productServices.createProduct(product);
    snackBarMessage("Producto nuevo ingresado con exito");
    }
    else{
      productServices.updateProduct(product);
      snackBarMessage("Producto actualizado con exito");
    }

    setState(() => saving = false);

    Navigator.pop(context);
  }

  void snackBarMessage(String message){
    final snackBar = SnackBar(
        content: Text(message),
      duration: const Duration(milliseconds: 4000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
