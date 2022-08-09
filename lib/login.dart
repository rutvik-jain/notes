import 'package:flutter/material.dart';
import 'package:notes/notes.dart';

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
        title: Text('Login'),
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
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return Note('', '');
                  }));
            },
                child: const Text('Login',style: TextStyle(
                    color: Colors.white,fontSize: 18),
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/signup');
                },
                    child: Text('SignUp now!')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
