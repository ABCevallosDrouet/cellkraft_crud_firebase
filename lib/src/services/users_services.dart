import 'package:cellkraft_crud_firebase/src/shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserServices{
  final String apli_key = "AIzaSyBOfuod78hqaeGu2v6T1YA9xJB2usCM1j8";
  final prefs = SharedUserPreferences();

  Future<bool> createNewUser(String? email, String? password) async {
    bool result = false;

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final Uri uri = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apli_key");

    final restAPIResponse = await http.post(uri, body: json.encode(authData));
    Map<String, dynamic> decodeResponse = json.decode(restAPIResponse.body);
    print(decodeResponse);

    if(decodeResponse.containsKey('idToken')){
      prefs.token = decodeResponse['idToken'];
      result = true;
    }

    return result;
  }

  Future<bool> createLogin(String? email, String? password) async {
    bool result = false;

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final Uri uri = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apli_key");

    final restAPIResponse = await http.post(uri, body: json.encode(authData));
    Map<String, dynamic> decodeResponse = json.decode(restAPIResponse.body);
    print(decodeResponse);

    if(decodeResponse.containsKey('idToken')){
      prefs.token = decodeResponse['idToken'];
      result = true;
    }

    return result;
  }
}