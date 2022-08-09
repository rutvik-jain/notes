import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signin'),
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
          ElevatedButton(onPressed: (){},
              child: const Text('Signin',style: TextStyle(
                  color: Colors.white,fontSize: 18),
              )),
        ],
      ),
    );
  }
}
