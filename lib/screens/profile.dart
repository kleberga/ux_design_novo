import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});


  Future<String?> pegarEmail() async {
    final prefs = await SharedPreferences.getInstance();
    var emailUser = await prefs.getString('user_email');
    return emailUser;
  }

  @override
  Widget build(BuildContext context) {


    final appBar = AppBar(
      title: Text("Perfil", style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: const Color(0xffc0ccda),
      automaticallyImplyLeading: true,
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 100,
                backgroundImage: Image.asset(
                  "assets/images/profile.png",
                  fit: BoxFit.cover,
                ).image,
              ),
            ),
            FutureBuilder(
                future: pegarEmail(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    var email = snapshot.data as String;
                    return Text(email);
                  } else {
                    return CircularProgressIndicator();
                  }
                }
            )
          ],
        ),

    );
  }
}
