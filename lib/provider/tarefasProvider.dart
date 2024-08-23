import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ux_design_novo/model/Tarefa.dart';

class TarefasProvider extends ChangeNotifier {

  var listaTarefas;


  Future<List<Tarefa>> readTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('user_id');
    try {
      var snapshot = FirebaseFirestore.instance.collection(id!).get();
      return snapshot.then(
            (querySnapshot) {
          return querySnapshot.docs.map((valor) {
            var mapData = valor.data();
              mapData['id'] = valor.id;
              return Tarefa.fromFirebaseDatabase(mapData);
          //}).toList().where((valor2) => valor2.data_concluida == concluidaStatus).toList();
          }).toList();
        },
      );
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw Exception(e.message);
    }
  }

  TarefasProvider(){
    listaTarefas = readTarefas();
  }

  Future<void> addTarefa(String titulo, String descricao, String data, String hora_ini,
      String hora_fim, String prioridade, String data_concluida) async {
        final prefs = await SharedPreferences.getInstance();
        final String? id = prefs.getString('user_id');
        var db = FirebaseFirestore.instance.collection(id!);
        return db.add({
          "titulo": titulo,
          "descricao": descricao,
          "data": data,
          "hora_ini": hora_ini,
          "hora_fim": hora_fim,
          "prioridade": prioridade,
          "data_concluida": data_concluida}).
        then((value) {
          print("Tarefa adicionada com sucesso!");
          listaTarefas = readTarefas();
          notifyListeners();
        }).catchError((error) => print("Falha ao adicionar tarefa: $error"));
  }

  Future<void> deleteTarefa(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('user_id');
    CollectionReference users = FirebaseFirestore.instance.collection(id!);
    return users.doc(userId).delete()
        .then((value){
      print("User deleted successfully!");
      listaTarefas = readTarefas();
      notifyListeners();
    }).catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> atualizarTarefa(String id, bool concluidaStatus) async {
    final prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('user_id');
    try {
      var snapshot = FirebaseFirestore.instance.collection(id_user!).doc(id);
      var dataAtual = DateTime.now();
      var data = DateFormat('dd/MM/yyyy').format(dataAtual).toString();
      await snapshot.update({
        'data_concluida': data,
      });
      listaTarefas = readTarefas();
      notifyListeners();
    } on FirebaseException catch (e) {
      debugPrint("Failed with error '${e.code}': ${e.message}");
      throw Exception(e.message);
    }
  }

}