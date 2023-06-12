import 'dart:async';

class Validators{

  final validateUser = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      RegExp regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

      if(regExp.hasMatch(email)){
        sink.add(email);
      }
        else{
          sink.addError("El correo no es correcto");
      }
    }
  );

  final validatePassword = StreamTransformer<dynamic, dynamic>.fromHandlers(
    handleData: (password, sink){
    if(password.length >= 6){
        sink.add(password);
      }
    else{
      sink.addError("Ingrese mas de 6 caracteres");
      }
    }
  );
}