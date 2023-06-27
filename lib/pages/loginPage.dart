import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphqlclient/widgets/myAppBar.dart';
import 'package:graphqlclient/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget
{
  const LoginPage({ Key? key }) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> 
{
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final Future<SharedPreferences> prefs=SharedPreferences.getInstance();
  Future<void> login(idToken) async
  {
    if(idToken=="failed")
    {
      return;
    }
    final SharedPreferences localStorage=await prefs;
    await localStorage.setString("token", idToken);
    nextPage();
  }
  void nextPage()
  {
    Navigator.pushReplacementNamed(context, "/home");
  }
  String userId="";
  Service service=Service();
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar:MyAppBar
      (
        titulo:"Iniciar sesion"
      ),
      body: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 20),
        
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
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
                  dynamic result=await service.getToken(password, email);
                  login(result['getAuth']);
                },
                child: const Text("Iniciar sesion")
              ),
            ),
            const SizedBox(height: 20),
            SizedBox
            (
              width: double.infinity,
              height: 40,
              child: ElevatedButton
              (
                onPressed: () async
                {
                  Navigator.pushNamed(context, "/signUp");
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