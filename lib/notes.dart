import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/newNote.dart';
import 'package:notes/login.dart';
import 'package:notes/profile.dart';
import 'package:notes/services/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Note extends StatefulWidget {
  final String title;
  final String description;
  Note(this.title,this.description);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  late SharedPreferences logindata;
  String? email;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Notes',style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return const Profile();
                }));
          },
              icon: const Icon(Icons.account_circle,color: Colors.redAccent,)),
          IconButton(onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            logindata.setBool('login', true);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return const Login();
                }));
           await FirebaseAuth.instance.signOut();
           googleSignIn.disconnect();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return Login();
            }));
          },
              icon: const Icon(Icons.logout,color: Colors.redAccent,))
        ],
      ),
      body:
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('notes').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }

            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, int index){
                    bool isDeleting = true;
                    final docID = snapshot.data!.docs[index].id;
                    final titleData = docs[index].get('title');
                    final descData = docs[index].get('description');
                    return Card(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                child: Text(
                                  titleData,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10,bottom: 5),
                                child: Text(
                                    descData,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,)
                                ),
                              ),
                            ],
                          ),
                          IconButton(onPressed: () async{
                            setState((){
                              isDeleting;
                            });
                            await FirebaseFirestore.instance.collection('notes').doc('$docID').delete();
                          },
                              icon: const Icon(Icons.remove,
                                color: Colors.redAccent,)),
                        ],
                      ),
                    );
                  });
            }
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return const NewNote();
        })
        );
      },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add,color: Colors.white,),),
      backgroundColor: Colors.black,
    );
  }
}
