import 'package:flutter/material.dart';
import 'package:graphqlclient/widgets/myAppBar.dart';
import 'package:graphqlclient/services/service.dart';
class InitPage extends StatefulWidget
{
  const InitPage({ Key? key }) : super(key: key);
  @override
  State<InitPage> createState() => _InitPageState();
}
class _InitPageState extends State<InitPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: MyAppBar
      (
        titulo: "GraphQL Client"
      ),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            const Text("Bienvenido a GraphQL Client"),
            ElevatedButton
            (
              onPressed:()
              {
                //vacio
              },
              child: const Text("Iniciar sesion")
            )
          ],
        ),
      ),
    );
  }
}