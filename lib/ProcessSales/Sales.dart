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
          title: const Text("Sales"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
                child: Text(
              "Choose Customer",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                StreamBuilder(
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
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        offset: Offset(5.0, 5.0), //(x,y)
                                        blurRadius: 8.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(customer[index]["CustomerName"].toString(),
                                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                                ),
                                                Text(customer[index]["CustomerPhone"].toString(),
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                                ),



                                              ],
                                            ),
                                          ),

                                          // Display customer information on the left
                                          // and an IconButton on the right
                                          Expanded(
                                            child: Container(
                                                // Your customer info here
                                                ),
                                          ),
                                          IconButton(
                                            onPressed: ()
                                            {
                                              String name = customer[index]["CustomerName"].toString();
                                              String phone =customer[index]["CustomerPhone"].toString();

                                              Addproduct.CustomerName=RxString(customer[index]["CustomerName"].toString());
                                              Get.to(() =>  invoicereport(), transition: Transition.leftToRight);
                                            }, icon: const Icon(Icons.arrow_forward),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    })
              ],
            )
          ],
        ));
  }
}
