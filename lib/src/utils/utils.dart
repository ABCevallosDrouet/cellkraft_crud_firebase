import 'package:flutter/material.dart';

bool isNumeric(String s){
  if(s.isEmpty) return false;

  //Retorna nulo si no puede hacer la convercion de la cadena de caracteres
  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void showAlert(BuildContext context, String message){
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("ADVERTENCIA"),
          content: Text(message),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Aceptar"),
            ),
          ],
        );
      });
}