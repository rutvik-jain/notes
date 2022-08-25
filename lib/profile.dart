import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // late SharedPreferences logindata;
  String? profilemail;
  String? profileuname;
  String? googlemail;
  String? guname;
  String? gpic;
  // String? gmail;
  // String? guser;
  // String? gimage;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var email = prefs.getString('email');
      var username = prefs.getString('username');
      var gmail = prefs.getString('gmail');
      var guser = prefs.getString('guser');
      // var gimage = prefs.getString('gimage');
      profilemail = email;
      profileuname = username;
      googlemail = gmail;
      guname = guser;
      // gpic = gimage;
      // email = logindata.getString('email');
      // username = logindata.getString('username');
      // gmail = logindata.getString('gmail');
      // gimage = logindata.getString('gimage');
      // guser = logindata.getString('guser');
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
              child: Text('Email:- $profilemail',style: TextStyle(fontSize: 22),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,right: 60),
              child: Text('Username:- $profileuname',style: TextStyle(fontSize: 22),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 120,left: 20),
              child: Text('Gmail:- $googlemail',style: TextStyle(fontSize: 22),),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10,right: 60),
            //   child: Image.network(gpic.toString()),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 10,right: 60),
              child: Text('Guser:- $guname',style: TextStyle(fontSize: 22),),
            ),
          ],
        ),
      ),
    );
  }
}
