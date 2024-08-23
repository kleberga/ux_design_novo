import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ux_design_novo/provider/tarefasProvider.dart';
import 'package:ux_design_novo/screens/addTarefa.dart';
import 'package:ux_design_novo/screens/home.dart';
import 'package:ux_design_novo/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ux_design_novo/screens/profile.dart';
import 'package:ux_design_novo/screens/register.dart';
import 'package:ux_design_novo/screens/tarefasConcluidas.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
          create: (context) => TarefasProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Login(),
          routes: {
            'home': (context) => Home(),
            'login': (context) => Login(),
            'registro': (context) => Register(),
            'addTarefa': (context) => AddTarefa(),
            'tarefasConcluidas': (context) => TarefasConcluidas(),
            'profile': (context) => Profile()
          },
        ),
      )
  );
}