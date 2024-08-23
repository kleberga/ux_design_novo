import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: const Color(0xffc0ccda),
      automaticallyImplyLeading: false,
    );

    return Scaffold(
      appBar: appBar,
      body: const Padding(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
        child: FormLogin(),
      )
    );
  }
}

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});
  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {

  var mostrarErro = false;
  var mensagemErro = '';
  final _formKeyLogin = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyLogin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  label: Text("E-mail", style: TextStyle(fontSize: 20),),
                  border: OutlineInputBorder(), icon: Icon(Icons.email)),
              validator: (value) {
                if (value == null || value.isEmpty ) {
                  return "Informe um e-mail";
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
                  if(_formKeyLogin.currentState!.validate()){
                    try {
                      var obterLogin = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: senhaController.text
                      );
                      setState(() {
                        mostrarErro = false;
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('user_id', obterLogin.user!.uid);
                      await prefs.setString('user_email', obterLogin.user!.email!);
                      Navigator.pushNamed(context, 'home');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-credential') {
                        setState(() {
                          mensagemErro = "Usuário ou senha inválidos!";
                          mostrarErro = true;
                        });
                        print("teste");
                      } else if(e.code == 'invalid-email') {
                        setState(() {
                          mensagemErro = "Informe um e-mail válido!";
                          mostrarErro = true;
                        });
                      } else {
                        setState(() {
                          mensagemErro = "Erro ao efetuar login!";
                          mostrarErro = true;
                        });
                      }
                    }
                  }
                },
                style: ButtonStyle(minimumSize: WidgetStateProperty.all<Size>(
                  Size(120, 50)
                ), backgroundColor: WidgetStateProperty.all<Color>(
                    Color(0xff47525e))),
                child: Text("Entrar",
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold
                ),
                )
            ),
            Padding(padding: EdgeInsets.only(top: 60)),
            Divider(
              color: Colors.black,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
          Center(
            child: InkWell(
              child: Text("Não está cadastrado? Efetue o registro",
                style: TextStyle(fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.purple[700],
                    decorationThickness: 2,
                    color: Colors.purple[700]),
              ),
              onTap: () => Navigator.pushNamed(context, 'registro'),
            )
          )
          ],
        )
    );
  }
}

