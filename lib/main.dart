import 'package:flutter/material.dart';
import 'package:notes/add_note.dart';

void main() {
  runApp(const MyApp());
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
        title: Text('Notes',style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),),
      ),
      body: ListView.builder(
        itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            return Card(
              color: Colors.black,
              child: Row(
                children: [
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
                      child: Text(widget.title,
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,bottom: 5),
                      child: Text(widget.description,
                            style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,)
                        ),
                    ),
                  ],
                ),
                  Align(
                    alignment: Alignment.topRight,
                      widthFactor: 5.2,
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                        },
                          icon: Icon(Icons.remove,
                        color: Colors.redAccent,))),
              ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return Add_note();
        }));
      },
      child: Icon(Icons.add,color: Colors.white,),
      backgroundColor: Colors.redAccent,),
      backgroundColor: Colors.black,
    );
  }
}
