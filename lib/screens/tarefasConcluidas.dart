import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/Tarefa.dart';
import '../provider/tarefasProvider.dart';

class TarefasConcluidas extends StatefulWidget {
  const TarefasConcluidas({super.key});

  @override
  State<TarefasConcluidas> createState() => _TarefasConcluidasState();
}

class _TarefasConcluidasState extends State<TarefasConcluidas> {

  var borderRadius = const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20),
      topLeft: Radius.circular(20), bottomLeft: Radius.circular(20));

  @override
  Widget build(BuildContext context) {

    final tarefaProvider = context.watch<TarefasProvider>();

    final appBar = AppBar(
      title: Text("Tarefas concluídas", style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: const Color(0xffc0ccda),
      automaticallyImplyLeading: true,
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: tarefaProvider.listaTarefas,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                var listaTarefas = snapshot.data as List<Tarefa>;
                var dataAtual = DateTime.now();
                var data = DateFormat('dd/MM/yyyy').format(dataAtual).toString();
                listaTarefas = listaTarefas.where((value) => value.data_concluida == data).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("Tarefas concluídas em: $data:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Expanded(
                      child: ListView.separated(
                        itemCount: listaTarefas.length,
                        itemBuilder: (context, index){
                          Tarefa tarefa = listaTarefas[index];
                          var colorPrioridade;
                          if(tarefa.prioridade == 'Alta'){
                            colorPrioridade = Colors.red;
                          } else if(tarefa.prioridade == 'Média'){
                            colorPrioridade = Colors.yellow;
                          } else {
                            colorPrioridade = Colors.green;
                          }
                          return ListTile(
                                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                                // minLeadingWidth: 12,
                                contentPadding: EdgeInsets.all(12),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(tarefa.titulo,
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 18.0),),
                                    Spacer(flex: 8,),
                                    Text('${tarefa.prioridade}',
                                      style: TextStyle(color: colorPrioridade, fontWeight: FontWeight.bold,
                                          fontSize: 18.0),),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${tarefa.descricao}',
                                        style: TextStyle(fontSize: 16.0)),
                                    Text('${tarefa.data}',
                                        style: TextStyle(fontSize: 16.0)),
                                    Text(
                                      'Hora de início: ${tarefa.hora_ini}',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    Text('Hora de término: ${tarefa.hora_fim}',
                                        style: TextStyle(fontSize: 16.0)),
                                  ],
                                ),
                                tileColor: Color(0xffd6dce0),
                              );
                        }, separatorBuilder: (BuildContext context, int index) => SizedBox(
                        height: 10,
                      ),
                      ),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
    );
  }
}

