import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ux_design_novo/provider/tarefasProvider.dart';

import '../model/Tarefa.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var borderRadius = const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20),
      topLeft: Radius.circular(20), bottomLeft: Radius.circular(20));

  @override
  Widget build(BuildContext context) {

    final tarefaProvider = context.watch<TarefasProvider>();
    final excluirTarefa = tarefaProvider.deleteTarefa;
    final atualizarTarefa = tarefaProvider.atualizarTarefa;

    final appBar = AppBar(
        title: Text("Home", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xffc0ccda),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black,),
            onPressed: () async{
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_id');
              await prefs.remove('user_email');
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, 'login');
            },
          ),
        ],
      leading: Builder(
          builder: (context) {
            return IconButton(
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu)
            );
          }
      ),
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
                listaTarefas = listaTarefas.where((value) => value.data_concluida.isEmpty).toList();
                return ListView.separated(
                  itemCount: listaTarefas.length,
                  itemBuilder: (context, index){
                    Tarefa tarefa = listaTarefas[index];
                    var colorPrioridade;
                    if(tarefa.prioridade == 'Alta'){
                      colorPrioridade = Colors.red;
                    } else if(tarefa.prioridade == 'Média'){
                      colorPrioridade = Colors.yellow[800];
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: () async {
                                    excluirTarefa(tarefa.id);
                                  },
                                ),
                                Padding(padding: EdgeInsets.only(left: 20)),
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green,),
                                  onPressed: ()  {
                                    atualizarTarefa(tarefa.id, true);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        tileColor: Color(0xffd6dce0),
                    );
                  }, separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 10,
                ),
                );
              }
              return CircularProgressIndicator();
            },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, 'addTarefa');
          },
        backgroundColor: Color(0xff3b4859),
        shape: const RoundedRectangleBorder( // <= Change BeveledRectangleBorder to RoundedRectangularBorder
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        child: Icon(Icons.add, color: Colors.white,),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xff1e2d3e),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white, width: 0.5)),
                color: Color(0xff1e2d3e)
              ),
                child: Text('Tasks Helper',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
            ),
            ListTile(
              title: const Text('Perfil',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, 'profile');
              },
            ),
            ListTile(
              title: const Text('Tarefa concluídas',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, 'tarefasConcluidas');
              },
            )
          ],
        ),
      ),
    );
  }
}
