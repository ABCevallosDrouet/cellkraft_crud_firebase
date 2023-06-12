import 'dart:io';

import 'package:cellkraft_crud_firebase/src/models/product_model.dart';
import 'package:cellkraft_crud_firebase/src/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<ProductsPage> {
  final productService  = ProductServices();

  @override
  Widget build(BuildContext context) {
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
              title: const Text("Productos"),
               actions: [
                 IconButton(
                     onPressed: () {
                       if (Platform.isAndroid) {
                         SystemNavigator.pop();
                       } else if (Platform.isIOS) {
                         exit(0);
                       }
                     },
                     icon: const Icon(Icons.exit_to_app)
                 )
               ],
      ),
             body: createListViewProduct(),
            floatingActionButton: createProduct(context),
          ),
      );
  }

  Widget createProduct(context){
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, "new_product").then((value) => setState((){})),
      backgroundColor: Colors.purple,
      child: const Icon(Icons.add),
    );
  }

  Widget createListViewProduct(){
    return FutureBuilder(
        future: productService.loadProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){

          if(snapshot.hasData){
            final productList = snapshot.data;

          return ListView.builder(
              itemCount: productList!.length,
              itemBuilder: (BuildContext context, int index) => createItem(context, productList[index])
              );
           }
          else{
            return const Center(
                child: CircularProgressIndicator()
            );
          }
        }
    );
  }

  Widget createItem(BuildContext context, ProductModel product){
    return Dismissible(
        key: UniqueKey(),
        background: Container(
        color: Colors.red,
      ),
      onDismissed: (DismissDirection direction) => productService.deleteProduct(product.id),
      child: Card(
        child: Column(
          children: [
            (product.fotoUrl != null && product.fotoUrl != "")
                ? FadeInImage(
                image: NetworkImage(product.fotoUrl!),
                placeholder: const AssetImage("assets/loading.gif"),
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
                )
                : const Image(image: AssetImage("assets/no_available_image.png")),
            ListTile(
              title: Text('${product.titulo} - ${product.valor}',
                style: const TextStyle(color: Colors.black, fontSize: 20),),
              subtitle: Text('${product.id}',
                style: const TextStyle(color: Colors.black),),
              onTap: () => Navigator.pushNamed(
                  context, 'new_product', arguments: product).then((value) => setState((){})),
            ),
          ],
        ),
      ),
    );
  }
}
