import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/notes.dart';
import 'package:notes/signup.dart';
import 'package:notes/services/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formGlobalKey = GlobalKey < FormState > ();

  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  late String email;
  late String password;
  final User? user = FirebaseAuth.instance.currentUser;

  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    CheckIfAlreadyLogin();
  }

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
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                      textAlign: TextAlign.start,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email'),
                      onChanged: (value) {
                        setState(() {
                          email = value;
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
                    textAlign: TextAlign.start,
                    controller: pwdController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password'),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    }
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                  onPressed: () async {

                    String email = emailController.text;
                    String password = pwdController.text;
                    String username = emailController.text.split('@')[0];

                    if (formGlobalKey.currentState!.validate()) {

                      // if (email != '' || !email.contains('@') && password != '' || password.length >= 6){
                      print('Successfull');
                      logindata.setBool('login', false);

                      logindata.setString('email', email);
                      logindata.setString('username', username);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (BuildContext context){
                            return Note('', '');
                          }));
                    }
                    else return;
                    print('login succeeded');
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text, password: pwdController.text)
                        .then((user){
                          print(user.user!.email);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (BuildContext context){
                                return Note('', '');
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
                child: SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // if(user != null && user!.email != null && user!.displayName != null) {
                      //   String? gmail = user!.email;
                      //   String? gimage = user!.photoURL;
                      //   String? guser = user!.displayName;
                      //   print(gmail);
                      //   print(guser);
                      //
                      //   print('Successfull');
                      //
                      //   // logindata.setBool('login', false);
                      //   logindata.setString('gmail', gmail!);
                      //   logindata.setString('guser', guser!);
                      //   // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //   //     builder: (BuildContext context){
                      //   //       return Note('', '');
                      //   //     }));
                      // }
                      signInWithGoogle().then((onValue){
                        logindata.setBool('login', false);
                        logindata.setString('gmail', umail!);
                        logindata.setString('guser', uname!);
                        FirebaseFirestore.instance.collection('Users').doc('auth').collection('gusers').
                        add({
                          'email': umail, 'image': imageUrl, 'name': uname,
                        });
                        if (onValue != null) {
                          Navigator.pushReplacement(context,MaterialPageRoute(
                              builder: (BuildContext context) {
                                return Note('', '');
                              }),
                          );
                        }
                        else return Login();
                        print("value -> ${onValue}");
                      });
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/img.png',height: 50,width: 50,),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Google'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context){
                          return const Signup();
                        }));
                  },
                      child: const Text('SignUp now!')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void CheckIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);

    print('newuser');
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