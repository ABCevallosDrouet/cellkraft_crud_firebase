import 'package:cellkraft_crud_firebase/src/bloc/login.bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget{
  static Provider? singleInstance;

  factory Provider({Key? key, required child}){

    /* if(singleInstance == null){
      singleInstance = Provider._internal(key: key, child: child);
    }*/
    //Operacion ternaria optima de la condicion
    singleInstance ??= Provider._internal(key: key, child: child);
    return singleInstance!;
  }

  //Constructor interno
  Provider._internal({Key? key, required super.child}) : super(key: key);


  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc? of (BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<Provider>())?.loginBloc;
  }
}