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
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   title: const Text('Login',
        //     style: TextStyle(color: Colors.redAccent),),
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formGlobalKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 70,right: 160),
                  child: Text('Welcome, Sign In',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 28),
                      child: Text('No Account?',style: TextStyle(fontSize: 16),),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                        return const Signup();
                      }));
                    },
                        child: const Text('No Account?',style: TextStyle(fontSize: 16),))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25),
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
                          focusedBorder: InputBorder.none,
                            labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        )),
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
                  padding: const EdgeInsets.only(left: 25,right: 25),
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
                          labelText: 'Password',
                          focusedBorder: InputBorder.none,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      }
                  ),
                ),
                const SizedBox(height: 50),

                ElevatedButton(
                    onPressed: () async {

                      String email = emailController.text;
                      String password = pwdController.text;
                      String username = emailController.text.split('@')[0];

                      if (formGlobalKey.currentState!.validate()) {
                        logindata.setBool('login', false);

                        logindata.setString('email', email);
                        logindata.setString('username', username);
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (BuildContext context){
                              return Note('', '');
                            }));
                      }
                      else return;
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text, password: pwdController.text)
                          .then((user){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (BuildContext context){
                                  return Note('', '');
                                })
                        );
                      });
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        padding: MaterialStateProperty.all(const EdgeInsets.only(top: 10,bottom: 10,left: 135,right: 135))),
                    child: const Text('Sign In',style: TextStyle(
                        color: Colors.white,fontSize: 18),
                    )),

                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 5,),
                  child: Row(
                    children: const [
                      Flexible(child: Divider(thickness: 1,
                        color: Colors.grey,indent: 30,endIndent: 1,)),
                      Flexible(child: Text('    or sign up via',style: TextStyle(fontSize: 16,color: Colors.grey),)),
                      Flexible(child: Divider(thickness: 1,
                        color: Colors.grey,indent: 20,endIndent: 10,)),
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
                          else {
                            return const Login();
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 100,right: 10),
                            child: Image.asset('assets/images/img_3.png',height: 25,width: 30,),
                          ),
                          const Text('Google',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ),
                  ),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text('Don\'t have an account?'),
                //     TextButton(onPressed: (){
                //       Navigator.push(context, MaterialPageRoute(
                //           builder: (BuildContext context){
                //             return const Signup();
                //           }));
                //     },
                //         child: const Text('SignUp now!')),
                //   ],
                // )
              const Padding(
                padding: EdgeInsets.only(top: 25,right: 85,),
                child: Text('By signin up to Notes you agree to our',style: TextStyle(color: Colors.grey,fontSize: 14,),),
              ),
                Padding(
                  padding: const EdgeInsets.only(right: 185),
                  child: TextButton(onPressed: (){},
                      child: const Text('terms and conditions')),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void CheckIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);

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