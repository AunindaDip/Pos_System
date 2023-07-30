import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class addcatagory extends StatefulWidget
{
  const addcatagory({super.key});
  @override
  State<addcatagory> createState() => _addcatagoryState();
}

class _addcatagoryState extends State<addcatagory> {


  final dbref=FirebaseDatabase.instance;
  TextEditingController catgoryname = TextEditingController();






  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [

          SizedBox(height: 20,),

          Center(
            child: Text("Add Catagories ",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
          ),


          SizedBox(
            height: 80,
          ),


          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Row(
              children:  [


                Expanded(
                  child: TextField(
                    controller:catgoryname ,

                    decoration: InputDecoration(
                        hintText: "Add category"
                        ,

                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ),
           SizedBox(
            height: 20,
          ),

          ElevatedButton(onPressed: (){

          dbref.ref().child("Category").push().set({
              "Name":catgoryname.text.toString()

            });
          catgoryname.clear();








          }, child: const Text("Save"))


        ],

      ),

    );


  }
}

