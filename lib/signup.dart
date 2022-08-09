import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/notes.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  final auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Signup',
          style: TextStyle(color: Colors.redAccent),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: TextField(
                controller: emailController,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                    labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                }
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: pwdController,
            textAlign: TextAlign.start,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: 'Password'),
            onChanged: (value){
              setState((){
                password = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: (){
              FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text,
                  password: pwdController.text).then((signedInUser){
                    FirebaseFirestore.instance.collection('users')
                        .add({'email': emailController.text, 'password': pwdController.text})
                        .then((value){
                          if (signedInUser != null){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context){
                                  return Note('', '');
                                }));
                          }
                    })
                    .catchError((e){
                      print(e);
                    });
              }).catchError((e){
                print(e);
              });
          },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
              child: const Text('Signin',style: TextStyle(
                  color: Colors.redAccent,fontSize: 18),
              )),
        ],
      ),
    );
  }
}
