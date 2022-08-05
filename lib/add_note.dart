import 'package:flutter/material.dart';
import 'package:notes/main.dart';

class Add_note extends StatefulWidget {
  const Add_note({Key? key}) : super(key: key);

  @override
  State<Add_note> createState() => _Add_noteState();
}
class _Add_noteState extends State<Add_note> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add Note',style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100,left: 30,right: 30),
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(
                  color: Colors.redAccent,
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: Offset(5.0, 5.0),
                )]
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.black,
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white,fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.white,fontSize: 16),
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 25,),
          SizedBox(
            width: 100,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return Note(titleController.text,descriptionController.text);
              }));
            },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                child: Text('ADD')),
          )
        ],
      ),
    );
  }
}
