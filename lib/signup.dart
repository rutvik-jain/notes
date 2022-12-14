import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/login.dart';
import 'package:notes/notes.dart';
import 'package:notes/services/users.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   title: Text('Signup',
        //     style: TextStyle(color: Colors.redAccent),),
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formGlobalKey,
            child: Column(
              children: [
                Image.asset('assets/images/img_2.png',width: 340,),
                const Padding(
                  padding: EdgeInsets.only(top: 40,right: 160),
                  child: Text('Sign Up to Notes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 28),
                      child: Text('Already have an account?',style: TextStyle(fontSize: 16,color: Colors.grey),),
                    ),
                    TextButton(onPressed: (){
                      Navigator.pop(context, MaterialPageRoute(builder: (BuildContext context){
                        return const Login();
                      }));
                    },
                        child: const Text('Login',style: TextStyle(fontSize: 16),))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25,top: 8),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      fillColor: Colors.white70,
                        filled: true,
                        hintText: 'Full Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25,top: 8),
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
                          fillColor: Colors.white70,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25,top: 8),
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
                        fillColor: Colors.white70,
                        filled: true,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                    onChanged: (value){
                      setState((){
                        password = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25,top: 8,bottom: 15),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                        fillColor: Colors.white70,
                        filled: true,
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
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
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                    padding: MaterialStateProperty.all(EdgeInsets.only(right: 100,left: 100))),
                    child: const Text('Create Account',style: TextStyle(
                        color: Colors.white,fontSize: 18),
                    )),

                 Padding(
                   padding: const EdgeInsets.only(top: 10,bottom: 5,),
                   child: Row(
                     children: const [
                       Flexible(child: Divider(thickness: 1,
                         color: Colors.grey,indent: 30,endIndent: 0,)),
                       Flexible(child: Padding(
                         padding: EdgeInsets.only(left: 20),
                         child: Text('or sign up via',style: TextStyle(fontSize: 16,color: Colors.grey),),
                       )),
                       Flexible(child: Divider(thickness: 1,
                         color: Colors.grey,indent: 15,endIndent: 15,)),
                     ],
                   ),
                 ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 0,primary: Colors.white,side: BorderSide(color: Colors.grey)),
                      onPressed: () async {
                        signInWithGoogle().then((onValue){
                          signupdata.setBool('login', false);
                          signupdata.setString('gmail', umail!);
                          signupdata.setString('guser', uname!);
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
                          else {
                            return const Signup();
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 100,right: 10),
                            child: Image.asset('assets/images/img_3.png',height: 25,width: 30,),
                          ),
                          const Text('Google',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 25,right: 85,),
                  child: Text('By signin up to Notes you agree to our',style: TextStyle(color: Colors.grey,fontSize: 14,),),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 185),
                  child: TextButton(onPressed: (){},
                      child: Text('terms and conditions')),
                ),
              ],
            ),
          ),
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
