import 'package:flutter/material.dart';
import 'package:graphqlclient/services/service.dart';
import 'package:graphqlclient/widgets/myAppBar.dart';
import 'package:intl/intl.dart';
class EditTaskPage extends StatefulWidget
{
  final String idTask;
  final String idUser;
  const EditTaskPage({ Key? key, required this.idTask, required this.idUser }) : super(key: key);
  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}
class _EditTaskPageState extends State<EditTaskPage>
{
  void regresar()
  {
    Navigator.pop(context, true);
  }
  Service service=Service();
  late DateTime date;
  @override
  void initState() {
    pedirDatos(widget.idTask);
    super.initState();
  }
  void pedirDatos(id)async
  {
    dynamic response=await service.getTaskInfo(id);
    setState(()
    {
      dynamic result=response['getTaskInfo'];
      controlTitulo.text=result['titulo'];
      controlDesc.text=result['descripcion'];
      date=DateTime.fromMillisecondsSinceEpoch(int.parse(result["fechaVencimiento"]));
      controlDate.text=DateFormat('yyyy-MM-dd').format(date);
    });
  }
  TextEditingController controlTitulo=TextEditingController();
  TextEditingController controlDesc=TextEditingController();
  TextEditingController controlDate=TextEditingController();
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: MyAppBar(titulo: "Editar Tarea"),
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
              controller: controlTitulo
            ),
            const Text("Ingresa descripcion de la tarea"),
            TextFormField
            (
              controller: controlDesc
            ),
            const Text("Ingresa fecha limite"),
            TextFormField
            (
              controller: controlDate,
              readOnly: true,
              onTap: ()
              {
                showDatePicker
                (
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2000),
                  lastDate:DateTime(2100),
                ).then((value)
                {
                  if(value!=null)
                  {
                    setState(()
                    {
                      date=value;
                      controlDate.text=DateFormat('yyyy-MM-dd').format(date);
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
                  dynamic result=await service.actualizarTask(widget.idUser, controlDesc.text, date, controlTitulo.text, widget.idTask);
                  if(result["updateTask"]==true)
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