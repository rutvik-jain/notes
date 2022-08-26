import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();

}

class _SignupState extends State<Signup> {
  final formGlobalKey = GlobalKey < FormState > ();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  final auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late SharedPreferences signupdata;
  late bool newuser;

  @override
  void initState(){
    super.initState();
    CheckIfAlreadyHaveAnAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Signup',
          style: TextStyle(color: Colors.redAccent),),
        centerTitle: true,
      ),
      body: Form(
        key: formGlobalKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 80),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
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
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password required atleast 6 digits!';
                  } else {
                    return null;
                  }
                },
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){
                String email = emailController.text;
                String password = pwdController.text;
                String username = emailController.text.split('@')[0];

                if (formGlobalKey.currentState!.validate()) {
                  signupdata.setBool('signup', false);

                  signupdata.setString('email', email);
                  signupdata.setString('username', username);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return Note('', '');
                      }));
                }
                else return;
                FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text,
                    password: pwdController.text).then((signedInUser){
                      FirebaseFirestore.instance.collection('users')
                          .add({'email': emailController.text, 'password': pwdController.text})
                          .then((value){
                            if (signedInUser != null){
                              Navigator.pushReplacement(context, MaterialPageRoute(
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
                child: const Text('Signup',style: TextStyle(
                    color: Colors.redAccent,fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }
  void CheckIfAlreadyHaveAnAccount() async {
    signupdata = await SharedPreferences.getInstance();
    newuser = (signupdata.getBool('signup') ?? true);

    if(newuser == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context){
            return Note('', '');
          }));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }
}
