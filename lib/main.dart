import 'package:cellkraft_crud_firebase/src/bloc/provider.dart';
import 'package:cellkraft_crud_firebase/src/pages/products_page.dart';
import 'package:cellkraft_crud_firebase/src/pages/new_product_page.dart';
import 'package:cellkraft_crud_firebase/src/pages/login_page.dart';
import 'package:cellkraft_crud_firebase/src/pages/register_page.dart';
import 'package:cellkraft_crud_firebase/src/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharedUserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            initialRoute: 'login',
            routes: {
              'login' : (BuildContext context) => LoginPage(),
              'register' : (BuildContext context) => RegisterPage(),
              'products' : (BuildContext context) => ProductsPage(),
              'new_product' : (BuildContext context) => NewProductPage()
            },
        )
    );
  }
}

