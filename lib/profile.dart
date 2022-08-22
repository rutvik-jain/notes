import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late SharedPreferences logindata;
  String? email;
  String? username;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email');
      username = logindata.getString('username');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      backgroundColor: Colors.black,
      title: Text('Profile',style: TextStyle(fontSize: 20,color: Colors.redAccent),),),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120,left: 20),
              child: Text('Email:- $email',style: TextStyle(fontSize: 22),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,right: 60),
              child: Text('Username:- $username',style: TextStyle(fontSize: 22),),
            )
          ],
        ),
      ),
    );
  }
}
