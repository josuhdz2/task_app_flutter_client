import 'package:flutter/material.dart';
import 'package:graphqlclient/pages/editTask.dart';
import 'package:graphqlclient/widgets/myAppBar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/service.dart';
class HomePage extends StatefulWidget
{
  const HomePage({ Key? key }) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>
{
  List<dynamic> lista=[];
  Service service=Service();

  final Future<SharedPreferences> prefs=SharedPreferences.getInstance();
  late String tokenId;
  int verificador=0;
  //
  @override
  void initState()
  {
    super.initState();

    obtenerTareas();
  }
  void salir()
  {
    Navigator.pop(context);
  }
  void obtenerTareas() async
  {
    final SharedPreferences localStorage=await prefs;
    String authlink=localStorage.getString("token").toString();
    if(authlink=='')
    {
      salir();
    }
    else
    {
      setState(()
      {
        tokenId=authlink;
      });
    }
    dynamic resultado=await service.getTareas(tokenId);
    setState(()
    {
      verificador++;
      print("resultado $verificador");
     lista=resultado["getTasks"]; 
     resultado=null;
    });
  }
  
  Future<void> logout() async
  {
    final SharedPreferences localStorage=await prefs;
    localStorage.remove("token");
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
      appBar: MyAppBar(titulo: "Home Page"),
      body: Center
      (
        child: Column
        (
          children:
          [
            const Text
            (
              "Todas las tareas:",
              style: TextStyle
              (
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox
            (
              height: MediaQuery.of(context).size.height*0.6,
              child: ListView.builder
              (
                itemCount: lista.length,
                itemBuilder: (BuildContext context, int index)
                {
                  final oneItem=lista[index];
                  String date=DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(int.parse(oneItem["fechaVencimiento"])));
                  return ListTile
                  (
                    onTap: ()async
                    {
                      final listener=await Navigator.push(context, MaterialPageRoute(builder: (context)=>EditTaskPage(idTask: oneItem["_id"], idUser: tokenId)));
                      if(listener==true)
                      {
                        obtenerTareas();
                      }
                    },
                    leading: const Icon
                    (
                      Icons.task,
                      color: Colors.blue,
                    ),
                    title: Text
                    (
                      oneItem["titulo"],
                      style: const TextStyle
                      (
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text
                    (
                      date,
                      style: const TextStyle
                      (
                        fontSize: 15,
                        color: Colors.grey
                      ),
                    ),
                    trailing: IconButton
                    (
                      icon:const Icon(Icons.delete),
                      color:Colors.red,
                      onPressed: ()async
                      {
                        print('esperando respuesta');
                        dynamic resultado1=await service.deleteTarea(tokenId, oneItem["_id"]);
                        print(resultado1);
                        if(resultado1['deleteTask']!=true)
                        {
                          print("error al eliminar");
                        }
                        else
                        {
                          print('ejecutado');
                          dynamic resultado=await service.getTareas(tokenId);
                          setState(()
                          {
                            print('listo para renderizar');
                            print(resultado["getTasks"]);
                            lista=resultado["getTasks"]; 
                          });
                        }
                      },
                    ),
                  );
                }
              ),
            ),
            SizedBox
            (
              width: double.infinity,
              height: 50,
              child: ElevatedButton
              (
                style: const ButtonStyle
                (
                  backgroundColor: MaterialStatePropertyAll<Color>( Colors.blueAccent)
                ),
                onPressed: ()async{
                  final escucha=await Navigator.pushNamed(context, "/agregarTarea");
                  if(escucha==true)
                  {
                    print("Regreso");
                    obtenerTareas();
                  }
                },
                child: const Text("Agregar nueva tarea")
              ),
            ),
            ElevatedButton
            (
              onPressed: ()async
              {
                logout();
              }, 
              child: const Text("Cerrar sesion")
            )
          ],),
      ),
    );
  }
}