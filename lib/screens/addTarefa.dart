import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ux_design_novo/provider/tarefasProvider.dart';

class AddTarefa extends StatelessWidget {
  const AddTarefa({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Adicionar Tarefa", style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: const Color(0xffc0ccda),
    );
    return Scaffold(
      appBar: appBar,
      body: const Padding(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
        child: AddTarefaForm()
      ),
    );
  }
}

class AddTarefaForm extends StatefulWidget {
  const AddTarefaForm({super.key});

  @override
  State<AddTarefaForm> createState() => _AddTarefaLoginState();
}

const List<String> opcoesDrop = <String>["Alta", "Média", "Baixa"];

class _AddTarefaLoginState extends State<AddTarefaForm> {

  final _formKeyAddTarefa = GlobalKey<FormState>();
  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  DateTime selectedData = DateTime.now();
  TimeOfDay selectedHoraIni = TimeOfDay.now();
  TimeOfDay selectedHoraFim = TimeOfDay.now();
  var horaFinal = DateTime(2000,1,1, TimeOfDay.now().hour, TimeOfDay.now().minute).add(Duration(hours: 1));

  TimeOfDay atualizarHoraFinal (){
    return selectedHoraFim = TimeOfDay(hour: horaFinal.hour, minute: horaFinal.minute);
  }


  _selectData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedData)
      setState(() {
        selectedData = picked;
      });
  }

  _selectHoraIni(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          );
        }
    );
    if (picked != null && picked != selectedHoraIni)
      setState(() {
        selectedHoraIni = picked;
      });
  }

  _selectHoraFim(BuildContext context) async {
    //var horaFinal = DateTime(2000,1,1, selectedHoraIni.hour, selectedHoraIni.minute).add(Duration(hours: 1));
    //TimeOfDay horaFinalAlt = TimeOfDay(hour: horaFinal.hour, minute: horaFinal.minute);
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: atualizarHoraFinal(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          );
        }
    );
    if (picked != null && picked != selectedHoraFim)
      setState(() {
        selectedHoraFim = picked;
      });
  }

  String dropdownValue = opcoesDrop.first;

  @override
  Widget build(BuildContext context) {

    final tarefaProvider = context.read<TarefasProvider>();
    final addTarefa = tarefaProvider.addTarefa;

    return SingleChildScrollView(
      child: Form(
          key: _formKeyAddTarefa,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: tituloController,
                decoration: InputDecoration(
                    label: Text("Título", style: TextStyle(fontSize: 20),)),
                validator: (value) {
                  if (value == null || value.isEmpty ) {
                    return "Informe um título";
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(
                    label: Text("Descrição (opcional)", style: TextStyle(fontSize: 20),)),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                        color: Colors.black38)
                    )
                ),
                child:Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Text("Data:", style: TextStyle(fontSize: 22, color: Color(0xff6d6972)),),
                      IconButton(
                          onPressed: () => _selectData(context),
                          icon: Icon(Icons.calendar_month)
                      ),
                      Text(
                          DateFormat('dd/MM/yyyy').format(selectedData).toString(),
                          style: TextStyle(fontSize: 22, color: Color(0xff6d6972))
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                        color: Colors.black38)
                    )
                ),
                child:Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Text("Hora de início:", style: TextStyle(fontSize: 22, color: Color(0xff6d6972)),),
                      IconButton(
                          onPressed: () => _selectHoraIni(context),
                          icon: Icon(Icons.punch_clock)
                      ),
                      Text(
                          DateFormat("HH:mm").
                          format(DateTime(2000,1,1, selectedHoraIni.hour, selectedHoraIni.minute)),
                          style: TextStyle(fontSize: 22, color: Color(0xff6d6972))
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                        color: Colors.black38)
                    )
                ),
                child:Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Text("Hora de término:", style: TextStyle(fontSize: 22, color: Color(0xff6d6972)),),
                      IconButton(
                          onPressed: () => _selectHoraFim(context),
                          icon: Icon(Icons.punch_clock),
                      ),
                      Text(
                          DateFormat("HH:mm").
                          format(DateTime(2000,1,1, selectedHoraFim.hour, selectedHoraFim.minute)),
                          style: TextStyle(fontSize: 22, color: Color(0xff6d6972))
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                        color: Colors.black38)
                    )
                ),
                child:Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Text("Prioridade:", style: TextStyle(fontSize: 22, color: Color(0xff6d6972)),),
                      Padding(padding: EdgeInsets.only(left: 15)),
                      Text(
                          dropdownValue,
                          style: TextStyle(fontSize: 22, color: Color(0xff6d6972))
                      ),
                      DropdownButtonHideUnderline (
                        child: DropdownButton(
                          iconSize: 36,
                            items: opcoesDrop.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value){
                              setState(() {
                                dropdownValue = value!;
                              });
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if(_formKeyAddTarefa.currentState!.validate()){
                          var data = DateFormat('dd/MM/yyyy').format(selectedData).toString();
                          var horaIni = DateFormat("HH:mm").format(DateTime(2000,1,1, selectedHoraIni.hour, selectedHoraIni.minute));
                          var horaFim = DateFormat("HH:mm").format(DateTime(2000,1,1, selectedHoraFim.hour, selectedHoraFim.minute));
                          addTarefa(tituloController.text,
                              descricaoController.text,
                              data,
                              horaIni,
                              horaFim,
                              dropdownValue,
                              '');
                          Navigator.pushNamed(context, 'home');
                        }
                      },
                      style: ButtonStyle(minimumSize: WidgetStateProperty.all<Size>(
                          Size(120, 50)
                      ), backgroundColor: WidgetStateProperty.all<Color>(
                          Color(0xff47525e))),
                      child: Text("Cadastrar",
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, 'home');
                      },
                      style: ButtonStyle(minimumSize: WidgetStateProperty.all<Size>(
                          Size(120, 50)
                      ), backgroundColor: WidgetStateProperty.all<Color>(
                          Color(0xff47525e))),
                      child: Text("Cancelar",
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}

