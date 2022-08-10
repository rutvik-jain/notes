import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:notes/notes.dart';
import 'package:notes/signup.dart';
import 'package:notes/services/users.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Login',
        style: TextStyle(color: Colors.redAccent),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
              print('login succeeded');
              FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text, password: pwdController.text)
                  .then((FirebaseUser){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContext context){
                            return const Note('', '');
                          })
                    );
              });
            },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Text('Login',style: TextStyle(
                    color: Colors.redAccent,fontSize: 18),
                )),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoogleSignInButton(
                darkMode: true,
                onPressed: (){
                  signInWithGoogle().then((onValue){
                    FirebaseFirestore.instance.collection('Users').doc('auth').collection('gusers').
                    add({
                      'email': email, 'image': imageUrl, 'name': name,
                    });
                  }).catchError((e){
                    print(e);
                  }).then((onValue){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context){
                          return Note('', '');
                        })
                    );
                  }).catchError((e){print((e));});
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return Signup();
                      }));
                },
                    child: const Text('SignUp now!')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
