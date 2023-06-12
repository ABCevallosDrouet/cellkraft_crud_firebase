import 'package:cellkraft_crud_firebase/src/services/users_services.dart';
import 'package:flutter/material.dart';
import '../bloc/login.bloc.dart';
import '../bloc/provider.dart';
import '../utils/utils.dart';

class RegisterPage extends StatelessWidget {
  final userService = UserServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(0, 160, 150, 0.9),
              Color.fromRGBO(220, 0, 180, 0.9)
            ]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            createLogo(context),
            registerForm(context),
          ],
        ),
      ),
    );
  }

  Widget createLogo(BuildContext context){
    final sizePage = MediaQuery.of(context).size;

    return Container(
      height: sizePage.height * 0.30,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 20,
              spreadRadius: 2.0,
            ),
          ]
      ),
      child: Image.asset("assets/logo..png"),
    );
  }

  Widget registerForm(BuildContext context){

    final loginBloc = Provider.of(context);
    final sizePage = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(height: 250)
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            width: sizePage.width * 0.85,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 20,
                    spreadRadius: 2.0,
                  ),
                ]
            ),
            child: Column(
              children: [
                const Text("Registrarse", style: TextStyle(
                  fontSize: 30,
                  color: Colors.black54,
                ),
                ),
                const SizedBox(height: 20,),
                createUser(loginBloc),
                const SizedBox(height: 20,),
                createPassword(loginBloc),
                const SizedBox(height: 30,),
                createButton(loginBloc)
              ],
            ),
          ),
          const SizedBox(height: 25,),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "login"),
              style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
              child: const Text("Si ya tienes un usuario, inicia sesion"),
          ),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget createUser(LoginBloc? bloc) {
    return StreamBuilder(
        stream: bloc?.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: const Icon(Icons.email_rounded, color: Colors.lightBlue),
                labelText: "Ingrese su correo",
                hintText: "ejemplo@correo.com",
                counterText: snapshot.data,
                errorText: snapshot.error?.toString(),
              ),
              onChanged: bloc?.emailSink.add,
            ),
          );
        }
    );
  }

  Widget createPassword(LoginBloc? bloc) {
    return StreamBuilder(
        stream: bloc?.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return  Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: const Icon(Icons.lock, color: Colors.purpleAccent),
                labelText: "Ingrese su nueva contraseña",
                errorText: snapshot.error?.toString(),
              ),
              onChanged: bloc?.passwordSink.add,
            ),
          );
        }
    );
  }

  Widget createButton(LoginBloc? bloc){
    return StreamBuilder(
        stream: bloc?.formValidationStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return  ElevatedButton(
              onPressed: snapshot.hasData ? () => register(context, bloc) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15),
                child: const Text("Aceptar",),
              )
          );
        }
    );
  }

  void register(BuildContext context, LoginBloc? bloc) async{
    print('Email: ${bloc?.email}');
    print('Password: ${bloc?.password}');

    if(await userService.createNewUser(bloc?.email, bloc?.password)) {
      Navigator.pushReplacementNamed(context, 'login');
    }
    else{
      showAlert(context, "Error al crear usuario");
    }
  }
}
