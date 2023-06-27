import 'package:flutter/material.dart';
import 'package:graphqlclient/pages/addTask.dart';
import 'package:graphqlclient/pages/editTask.dart';
import 'package:graphqlclient/pages/loginPage.dart';
import 'package:graphqlclient/pages/homePage.dart';
import 'package:graphqlclient/pages/signUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()
{
  /*final String? url;
  final Future<SharedPreferences> prefs=SharedPreferences.getInstance();
  Future<String> verificar() async
  {
    final SharedPreferences localStorage=await prefs;
    final String? tokenId=localStorage.getString("token");
    return tokenId.toString();
  }*/
  runApp
  (
    MaterialApp
    (
      debugShowCheckedModeBanner: false,
      title: "Graphql Client",
      routes: {
        '/login':(context)=> const LoginPage(),
        '/home':(context)=>const HomePage(),
        '/agregarTarea':(context)=>const TaskForm(),
        '/signUp':(context)=>const SignUpPage()
      },
      home: const Router(),
    )
  );
}
class Router extends StatefulWidget
{
  const Router({ Key? key }) : super(key: key);
  @override
  State<Router> createState() => _RouterState();
}
class _RouterState extends State<Router>
{
  @override
  void initState()
  {
    verificar();
    super.initState();
  }
  Future<void> verificar() async
  {
    final SharedPreferences localStorage=await SharedPreferences.getInstance();
    final String tokenId=localStorage.getString("token") ?? '';
    setState(()
    {
      if(tokenId!='')
      {
        Navigator.pushReplacementNamed(context, "/home");
      }
      else
      {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return const Scaffold
    (
      body: CircularProgressIndicator(),
    );
  }
}