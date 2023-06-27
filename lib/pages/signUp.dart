import 'package:flutter/material.dart';
import 'package:graphqlclient/services/service.dart';
import 'package:graphqlclient/widgets/myAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignUpPage extends StatefulWidget
{
  const SignUpPage({ Key? key }) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage>
{
  Service service=Service();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController nombreController=TextEditingController();
  void signUp(result)async
  {
    if(result=="failed")
    {
      return;
    }
    nextPage();
  }
  void nextPage()
  {
    Navigator.pushReplacementNamed(context, "/login");
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: MyAppBar(titulo: "Registrate"),
      body: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 20),
        
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            const Text("Nombre de Usuario:"),
            TextFormField
            (
              controller: nombreController,
            ),
            const Text("Email:"),
            TextFormField
            (
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
            ),
            const Text("Password:"),
            TextFormField
            (
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox
            (
              width: double.infinity,
              height: 40,
              child: ElevatedButton
              (
                onPressed: () async
                {
                  String email=emailController.text;
                  String password=passwordController.text;
                  String nombre=nombreController.text;
                  dynamic result=await service.signUpUsuario(nombre, email, password);
                  signUp(result['createUser']);
                },
                child: const Text("Registrate")
              ),
            )
          ],
        ),
      ),
    );
  }
}