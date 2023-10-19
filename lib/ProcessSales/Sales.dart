import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:pos/ProcessSales/InvoiceReport.dart';

class sales extends StatefulWidget {
  const sales({super.key});
  @override
  State<sales> createState() => _salesState();
}

class _salesState extends State<sales> {
  final ref = FirebaseDatabase.instance.ref("Customer");
  final addproductcontroller Addproduct = Get.find<addproductcontroller>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Choose Customer",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: Column(
          children: [



            Expanded(
              child: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> customer = [];
                      if (snapshot.data?.snapshot.value != null) {
                        Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                        customer = map.values.toList();
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: customer.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Addproduct.CustomerName=RxString(customer[index]["CustomerName"].toString());
                              Get.to(() =>  invoicereport(), transition: Transition.leftToRight);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Left side of the container with image
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'lib/assets/Images/default_image.jpg', // Replace with your image path
                                        width: 60, // Adjust the width as needed
                                        height: 60, // Adjust the height as needed
                                      ),
                                    ),
                                    // Right side of the container with customer information
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              customer[index]["CustomerName"].toString(),
                                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              customer[index]["CustomerPhone"].toString(),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.greenAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ));
  }
}
