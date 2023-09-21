import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pos/Controller/cartcontroller.dart';
import 'package:pos/Modelclass/productmodel.dart';
import 'package:get/get.dart';
import 'package:pos/ProcessSales/InvoiceReport.dart';


class ProductListForInvoice extends StatefulWidget {
  const ProductListForInvoice({super.key});

  @override
  State<ProductListForInvoice> createState() => _ProductListForInvoiceState();
}

class _ProductListForInvoiceState extends State<ProductListForInvoice> {
  final ref = FirebaseDatabase.instance.ref("Product Details");

  final cartController = Get.find<CartController>(); // Get the CartController instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> products = [];
                    if (snapshot.data?.snapshot.value != null) {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      products = map.values.toList();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
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
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child:
                                            Text("Name:" + products[index]['Name'].toString(),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${"Price = " +
                                                  products[index]
                                                      ['Selling price'].toString()}Tk.",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                          ),

                                          ElevatedButton(onPressed: (){
                                            final product = Product(
                                                RxString(products[index]['Name']),
                                              double.parse(products[index]['Selling price']),
                                              RxInt(int.parse(products[index]["Quantity"].toString())), // Use RxInt here
                                              RxInt(1),
                                              RxString(products[index]["Product_id"]),
                                            );
                                            print (products[index].toString());
                                            cartController.addToCart(product, 1); // Assuming you want to add 1 quantity.
                                            Get.to(() => invoicereport());



                                          }, child: Text("Add "))

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
