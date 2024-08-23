import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatelessWidget {
  const Register({super.key});


  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      title: Text("Registro", style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: const Color(0xffc0ccda),
    );

    return Scaffold(
      appBar: appBar,
      body: const Padding(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
        child: FormRegister(),
      )
    );
  }
}

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormRegister> {

  var mostrarErro = false;
  var mensagemErro = '';
  final _formKeyRegister = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  Widget fnMostrarErro(){
    return Text(mensagemErro, style: TextStyle(color: Colors.red, fontSize: 18),);
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  static const emailTest = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  final regex = RegExp(emailTest);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyRegister,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  label: Text("E-mail", style: TextStyle(fontSize: 20),),
                  border: OutlineInputBorder(), icon: Icon(Icons.email)),
              validator: (value) {
                if (value == null || value.isEmpty || !regex.hasMatch(value)) {
                  return 'Informe um e-mail válido!';
                }
                return null;
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            TextFormField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(
                  label: Text("Senha", style: TextStyle(fontSize: 20),),
                  border: OutlineInputBorder(), icon: Icon(Icons.key)),
              validator: (value) {
                if (value == null || value.isEmpty ) {
                  return "Informe uma senha";
                }
                return null;
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
                onPressed: () async {
                  if(_formKeyRegister.currentState!.validate()){
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: senhaController.text
                      );
                      setState(() {
                        mostrarErro = false;
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('user_id', userCredential.user!.uid);
                      Navigator.pushNamed(context, 'home');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        setState(() {
                          mensagemErro = "Erro: este e-mail já está registrado. Efetue login.";
                          mostrarErro = true;
                        });
                      } else {
                        setState(() {
                          mensagemErro = "Erro: não foi possível efetuar o registro!";
                          mostrarErro = true;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                style: ButtonStyle(minimumSize: WidgetStateProperty.all<Size>(
                  Size(120, 50)
                ), backgroundColor: WidgetStateProperty.all<Color>(
                    Color(0xff47525e))),
                child: Text("Efetuar o cadastro",
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold
                ),
                )
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              child: mostrarErro ? fnMostrarErro() : SizedBox.shrink(),
            ),
            Padding(padding: EdgeInsets.only(top: 60)),
            Divider(
              color: Colors.black,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
                child: InkWell(
                  child: Text("Já está cadastrado? Efetue o login",
                    style: TextStyle(fontSize: 18,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.purple[700],
                        decorationThickness: 2,
                        color: Colors.purple[700]),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'login'),
                )
            )
          ],
        )
    );
  }
}

