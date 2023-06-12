
import 'package:shared_preferences/shared_preferences.dart';

class SharedUserPreferences{
 static SharedUserPreferences? singleInstance;

 factory SharedUserPreferences(){
   //Operacion ternaria optima de la condicion
   singleInstance ??= SharedUserPreferences._internal();

   return singleInstance!;
 }
  //Constructor interno
 SharedUserPreferences._internal();

 late SharedPreferences prefs;

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  set token(String token){
    prefs.setString('token', token);
  }

  String get token{
    return prefs.getString('token')!;
  }


}