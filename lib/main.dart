import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/add_note.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Note('',''),
    );
  }
}

class Note extends StatefulWidget {
  final String title;
  final String description;
  const Note(this.title,this.description);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
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
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError)
            return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: 2,
                itemBuilder: (_, int index){
                final titledata = docs[index].get('title');
                final descdata = docs[index].get('description');
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
                              titledata[index],
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,fontWeight: FontWeight.bold,
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,bottom: 5),
                            child: Text(
                              descdata[index],
                                  style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,)
                              ),
                          ),
                        ],
                      ),
                        if(widget.title.isNotEmpty)
                        IconButton(onPressed: (){},
                            icon: const Icon(Icons.remove,
                          color: Colors.redAccent,)),
                    ],
                    ),
                  );
                });
          }
          else return Center(
            child: CircularProgressIndicator(),
          );
          }
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return Add_note();
        })
        );
      },
      backgroundColor: Colors.redAccent,
      child: const Icon(Icons.add,color: Colors.white,),),
      backgroundColor: Colors.black,
    );
  }
}
