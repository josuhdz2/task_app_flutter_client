import 'package:flutter/material.dart';
import 'package:graphqlclient/services/service.dart';
import 'package:graphqlclient/widgets/myAppBar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TaskForm extends StatefulWidget
{
  const TaskForm({ Key? key }) : super(key: key);
  @override
  State<TaskForm> createState() => _TaskFormState();
}
class _TaskFormState extends State<TaskForm>
{
  DateTime selectedDate=DateTime(2000);
  TextEditingController controlTitulo=TextEditingController();
  TextEditingController controlDescripcion=TextEditingController();
  late String tokenId;
  Service service=Service();
  @override
  void initState()
  {
    obtenerToken();
    super.initState();
  }
  void obtenerToken() async
  {
    final SharedPreferences localStorage=await SharedPreferences.getInstance();
    setState(()
    {
      tokenId=localStorage.getString("token").toString();
    });
  }
  void regresar()
  {
    Navigator.pop(context, true);
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: MyAppBar(titulo: "Agregar nueva tarea"),
      body: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            const Text("Ingresa titulo de la tarea"),
            TextFormField
            (
              controller: controlTitulo,
            ),
            const Text("Ingresa descripcion de la tarea"),
            TextFormField
            (
              controller: controlDescripcion,
            ),
            const Text("Ingresa fecha limite"),
            TextFormField
            (
              controller: TextEditingController
              (
                text: DateFormat('yyyy-MM-dd').format(selectedDate)
              ),
              readOnly: true,
              onTap: ()
              {
                showDatePicker
                (
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate:DateTime(2100),
                ).then((value)
                {
                  if(value!=null)
                  {
                    setState(()
                    {
                      selectedDate=value;
                    });
                  }
                });
              },
            ),
            SizedBox
            (
              width: double.infinity,
              child: ElevatedButton
              (
                onPressed: ()async
                {
                  String titulo=controlTitulo.text;
                  String desc=controlDescripcion.text;
                  String fecha=selectedDate.toString();
                  dynamic result=await service.createTarea(tokenId, titulo, desc, fecha);
                  if(result["createTask"]==true)
                  {
                    regresar();
                  }
                },
                child: const Text("Agregar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}