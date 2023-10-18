import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pos/Controller/cartcontroller.dart';
import 'package:pos/Modelclass/productmodel.dart';
import 'package:pos/ProcessSales/InvoiceReport.dart';


class ProductListForInvoice extends StatefulWidget {
  const ProductListForInvoice({super.key});

  @override
  State<ProductListForInvoice> createState() => _ProductListForInvoiceState();
}

class _ProductListForInvoiceState extends State<ProductListForInvoice> {
  final ref = FirebaseDatabase.instance.ref("Product Details");
  bool _isLoading = false;
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: SizedBox(
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
                            height: 120,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(5.0, 5.0), //(x,y)
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 180,
                                  width:
                                  MediaQuery.of(context).size.width * 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(
                                        products[index]['url'],
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                  .expectedTotalBytes !=
                                                  null
                                                  ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 10), // Add this SizedBox for spacing

                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index]['Name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Stock:${products[index]['Quantity']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.green),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Tk." +
                                            products[index]['Selling price'],
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                          17, // Adjust the font size as needed
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "Add",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.deepOrange)
                                        ,
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            final product = Product(
                                              RxString(products[index]['Name']),
                                              double.parse(products[index]['Selling price']),
                                              RxInt(int.parse(products[index]["Quantity"].toString())), // Use RxInt here
                                              RxInt(1),
                                              RxString(products[index]["Product_id"]),
                                            );
                                            print (products[index].toString());
                                            cartController.addToCart(product, 1); // Assuming you want to add 1 quantity.
                                            Get.to(() => const invoicereport());

                                          },
                                          icon: const Icon(
                                              color: Colors.deepOrange,

                                              Icons.add_shopping_cart))
                                    ],
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
