import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/login.dart';
import 'package:notes/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var username = prefs.getString('username');
  var gmail = prefs.getString('gmail');
  var guser = prefs.getString('guser');
  // var gimage = prefs.getString('gimage');
  print(email);
  print(username);
  print(gmail);
  print(guser);
  // print(gimage);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null || gmail == null ? Login() : Note('', '')));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}