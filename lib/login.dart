import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:keepnotes/colors.dart';
import 'package:keepnotes/home.dart';
import 'package:keepnotes/services/auth.dart';
import 'package:keepnotes/services/firestore_db.dart';
import 'package:keepnotes/services/login_info.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Keep Notes',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(Buttons.Google, onPressed: () async {
              await signInWithGoogle();
              final User? currentUser = await _auth.currentUser;
              LocalDataSaver.saveLoginData(true);
              LocalDataSaver.saveImg(
                currentUser!.photoURL.toString(),
              );
              LocalDataSaver.saveMail(
                currentUser.email.toString(),
              );
              LocalDataSaver.saveName(
                currentUser.displayName.toString(),
              );
              LocalDataSaver.saveSyncSet(false);
              await FireDB().getAllStoredNotes();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
