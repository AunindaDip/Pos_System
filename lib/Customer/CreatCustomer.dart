import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class creatCustomer extends StatefulWidget {
  const creatCustomer({super.key});
  @override
  State<creatCustomer> createState() => _creatCustomerState();
}

class _creatCustomerState extends State<creatCustomer> {
  TextEditingController customername = TextEditingController();
  TextEditingController CustomerEmail = TextEditingController();
  TextEditingController CustomerAddress = TextEditingController();
  TextEditingController CustomerPhone = TextEditingController();

  final addproductcontroller addcustomercontroller = Get.find<addproductcontroller>();
  final dbref = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Creat Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: customername,
              decoration: const InputDecoration(
                  hintText: "Customer Name  ",
                  labelText: "Name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: CustomerEmail,
              decoration: const InputDecoration(
                  hintText: "Customer Email  ",
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: CustomerAddress,
              decoration: const InputDecoration(
                  hintText: "Customer Address  ",
                  labelText: "Address",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: CustomerPhone,
              decoration: const InputDecoration(
                  hintText: "Customer Phone  ",
                  labelText: "Mobile Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (customername.text.isEmpty ||
                      CustomerEmail.text.isEmpty ||
                      CustomerAddress.text.isEmpty ||
                      CustomerPhone.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Please enter both mobile and password',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    Future.delayed(Duration(seconds: 2), () {
                      savetodatabase(
                        customername,
                        CustomerEmail,
                        CustomerAddress,
                        CustomerPhone,
                      ).then((_) {
                        // Close the loading screen when the saving is complete
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    });

                    addcustomercontroller.addcustomer.value = true;
                  }
                },
                child: const Text("Save to Database"))
          ],
        ),
      ),
    );
  }

  savetodatabase(
      TextEditingController customername,
      TextEditingController customerEmail,
      TextEditingController customerAddress,
      TextEditingController customerPhone) {
    try {
      dbref.ref().child("Customer").push().set({
        "CustomerName":customername.text.toString(),
        "CustomerMail":customerEmail.text.toString(),
        "CustomerPhone":customerPhone.text.toString(),
        "CustomerAddress":customerAddress.text.toString(),
      });

      customername.clear();
      customerEmail.clear();
      customerPhone.clear();
      customerAddress.clear();

      Fluttertoast.showToast(
        msg: 'Data saved successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      addcustomercontroller.addproductbool.value = false;
    } on Exception catch (e) {
      addcustomercontroller.addproductbool.value = false;


    }
  }
}
