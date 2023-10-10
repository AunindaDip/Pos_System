import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pos/Controller/CatagoryController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final dbref = FirebaseDatabase.instance;
  TextEditingController categoryName = TextEditingController();
  final ref = FirebaseDatabase.instance.ref("Category");
  final  catagorycontroller catgorcontroller =
  Get.find<catagorycontroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Add Categories ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: categoryName,
                    decoration: const InputDecoration(
                      hintText: "Add category",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {

              catgorcontroller.setLoading(true);

              await Future.delayed(Duration(seconds: 2));



              dbref
                  .ref()
                  .child("Category")
                  .push()
                  .set({"Name": categoryName.text.toString()});
              categoryName.clear();

              catgorcontroller.setLoading(false);
              showToast("Category added successfully!");



            },
            child: const Text("Save"),




          ),



          Obx(() {
            return Visibility(
              visible: catgorcontroller.isLoading.value,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),



          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final Map<dynamic, dynamic>? data =
                        snapshot.data?.snapshot.value;
                    if (data != null) {
                      List<dynamic> categoryList = [];
                      data.forEach((key, value) {
                        categoryList.add({"key": key, "Name": value["Name"]});
                      });

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: categoryList.length,
                        itemBuilder: (context, int index) {
                          var category = categoryList[index];
                          var categoryName = category['Name'];
                          var categoryKey = category['key'];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),

                            ),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(categoryName,style: TextStyle(
                                            fontSize: 17,fontWeight: FontWeight.bold
                                          ),),

                                       Spacer(),
                                          TextButton.icon(
                                            onPressed: () {
                                              _editCategoryDialog(
                                                  categoryName, categoryKey);
                                            },

                                            icon: const Icon(Icons.delete,color: Colors.blueGrey,),

                                            label: Text("Edit",
                                              style: TextStyle(color: Colors.blueGrey),),
                                          ),






                                          Spacer(),



                                          TextButton.icon(
                                            onPressed: () {
                                              _deleteCategory(categoryKey);
                                            },

                                            icon: const Icon(Icons.delete,color: Colors.red,),

                                            label: const Text("Delete",
                                            style: TextStyle(color: Colors.red),),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // Return an empty container as a fallback.
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editCategoryDialog(String categoryName, String categoryKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editingController =
        TextEditingController(text: categoryName);

        return AlertDialog(
          title: const Text("Edit Category"),
          content: TextField(
            controller: editingController,
            decoration: const InputDecoration(
              hintText: "Enter new category name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Update the category in Firebase
                dbref
                    .ref()
                    .child("Category")
                    .child(categoryKey)
                    .update({"Name": editingController.text});
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(String categoryKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: const Text("Are you sure you want to delete this category?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Delete the category from Firebase
                dbref.ref().child("Category").child(categoryKey).remove();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  void showToast(String message) {
    // You can use Fluttertoast or any other method to display the toast
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
