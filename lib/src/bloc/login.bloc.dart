import 'dart:async';
import 'package:cellkraft_crud_firebase/src/bloc/validators.dart' as val;
import 'package:rxdart/rxdart.dart';

class LoginBloc{
  final emailStreamController = BehaviorSubject<String>();
  final passwordStreamController = BehaviorSubject<dynamic>();

  //Insertar informacion en el stream
    Sink<String> get emailSink => emailStreamController.sink;
    Sink<dynamic> get passwordSink => passwordStreamController.sink;

  //Recuperar informacion del Stream
    Stream<String> get emailStream => emailStreamController.stream.transform(val.Validators().validateUser);
    Stream<dynamic> get passwordStream => passwordStreamController.stream.transform(val.Validators().validatePassword);
    Stream<bool> get formValidationStream => Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

    //Obtener el ultimo valor emitido en el stream
    String get email => emailStreamController.value;
    String get password => passwordStreamController.value;


  //Cerrar el stream
    dispose(){
      emailStreamController.close();
      passwordStreamController.close();
    }
}