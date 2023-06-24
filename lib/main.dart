import 'package:flutter/material.dart';
import 'package:keepnotes/login.dart';
import 'package:keepnotes/services/login_info.dart';
import 'package:keepnotes/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:keepnotes/colors.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  //Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogIn = false;

  getLoggedInState() async {
    await LocalDataSaver.getLogData().then((value) {
      setState(() {
        isLogIn = value.toString() == "null";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keep Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: black,
          secondary: black,
        ),
      ),
      home: isLogIn ? const Login() : const Home(),
    );
  }
}
