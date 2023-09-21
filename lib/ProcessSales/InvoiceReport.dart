
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:pos/Controller/cartcontroller.dart';
import 'package:pos/ProcessSales/ProductListFor_Invoice.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class invoicereport extends StatefulWidget {
  final String? customerName, customerPhone;
  const invoicereport(
      {super.key,
      this.customerName,
      this.customerPhone}); // Use '?' in constructor
  @override
  State<invoicereport> createState() =>
      _invoicereportState(customerName, customerPhone);
}

class _invoicereportState extends State<invoicereport> {
  _invoicereportState(customerName, customerPhone);
  final ref = FirebaseDatabase.instance.ref("Product Details");
  final TextEditingController _customerNameController =
      TextEditingController(); // Create a TextEditingController
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final addproductcontroller Addproduct = Get.find<addproductcontroller>();
  final CartController cart = Get.find<CartController>();
  final dbref = FirebaseDatabase.instance;
  int _invoiceNumber = 0; // Initialize with a default value

  int nextCounter = 1; // Initialize nextCounter

  @override
  void initState() {
    super.initState();
    _fetchAndUpdateCounter();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Generate Sales"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText:nextCounter.toString(),
                          labelText: "Inv No.",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          border: const OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "",
                          labelText: "Date",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null &&
                                  pickedDate != _selectedDate) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                  _selectedDate = pickedDate;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                          )),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _dateFormat
                            .format(_selectedDate), // Display selected date
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Customer Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        Addproduct.CustomerName.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(219, 212, 255, 1),
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        Get.to(() => const ProductListForInvoice(),
                            transition: Transition.leftToRight);
                      },
                      child: const Text(
                        "Add Products",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ))),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => cart.length.value > 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 160,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: cart.cartItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("yes"),
                                                  content: const Text(
                                                      "Are you Sure You Want To Delete This"),
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          fontSize: 20),
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      32.0))),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const invoicereport()),
                                                          );
                                                        },
                                                        child:
                                                            const Text("No")),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);

                                                        cart.removeFromCart(cart
                                                            .cartItems[index]);
                                                      },
                                                      child: const Text("Yes"),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(Icons.delete)),
                                    Obx(() => Text(
                                          cart.cartItems[index].name.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (cart.cartItems[index].quantity
                                                .value >
                                            1) {
                                          cart.cartItems[index].quantity
                                              .value--;
                                        }
                                        if (cart.cartItems[index].quantity
                                                .value ==
                                            0) {
                                          // If quantity is less than 1, remove the product from the list
                                          cart.removeFromCart(
                                              cart.cartItems[index]);
                                        }
                                      },
                                    ),
                                    Obx(() {
                                      if (index >= 0 &&
                                          index < cart.cartItems.length) {
                                        return Text(
                                          cart.cartItems[index].quantity.value
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        return const Text(
                                            'Invalid Index'); // Handle the case when index is out of bounds
                                      }
                                    }),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        if (cart.cartItems[index].quantity
                                                .value <
                                            cart.cartItems[index].stock.value) {
                                          cart.cartItems[index].quantity
                                              .value++;
                                        }
                                      },
                                    ),
                                    const Spacer(),
                                    Obx(() => Text(
                                          (cart.cartItems[index].quantity
                                                          .value *
                                                      cart.cartItems[index]
                                                          .price)
                                                  .toString() +
                                              ("0Tk"),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white70,
                      offset: Offset(5.0, 5.0),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(219, 212, 255, 1),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(
                              () => Text(
                                cart.totalAmount.toString().isEmpty
                                    ? "0.00Tk."
                                    : cart.totalAmount.toString() + "Tk.",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Discount",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 80, // Adjust the width as needed
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Enter discount',
                                // Other decoration properties like borders, icons, etc.
                              ),

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),

                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true), // Allow decimal input
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d*\.?\d{0,2}')), // Allow only numeric input with up to 2 decimal places
                              ],

                              onChanged: (value) {
                                double discountValue =
                                    double.tryParse(value) ?? 0.0;

                                cart.setDiscount(discountValue);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(
                            () => Text(
                              cart.afterdiscount.toString().isEmpty
                                  ? "0.00Tk."
                                  : "${cart.afterdiscount}Tk.",
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Paid Amount",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 80, // Adjust the width as needed
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Enter Amount',

                                // Other decoration properties like borders, icons, etc.
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),

                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true), // Allow decimal input
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d*\.?\d{0,2}')), // Allow only numeric input with up to 2 decimal places
                              ],

                              onChanged: (value) {
/*
*/
                                double paid = double.tryParse(value) ?? 0.0;

                                cart.setPaidammount(paid);

                                // This function is called whenever the text in the TextField changes
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Due Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Obx(
                            () => Text(
                              cart.afterpaid.toString().isEmpty
                                  ? "0.00Tk."
                                  : cart.afterpaid.toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  savetodatabase(nextCounter.toString());
                },
                child: const Text("Proceed Sell"))
          ],
        ),
      ),
    );
  }

  Future<void> _fetchAndUpdateCounter() async {
    DatabaseReference counterRef = dbref.ref().child("Sells_Counter ");
    DatabaseEvent counterSnapshot = await counterRef.once();

    int currentCounter = (counterSnapshot.snapshot.value as int?) ?? 1;
    print(currentCounter.toString());

    // Increment the counter for the next sale
    int nextCounter = currentCounter + 1;

    // Update the counter value in the database
    await counterRef.set(nextCounter); // Await the set operation

    // Update the nextCounter value in the state
    setState(() {
      this.nextCounter = nextCounter;
    });
  }






  Future<void> savetodatabase(String slnum) async {

    try {
      List<Map<String, dynamic>> productsData = [];

      for (var item in cart.cartItems) {
        Query queryRef = dbref
            .ref()
            .child("Product Details")
            .orderByChild('Product_id')
            .equalTo(item.firebaseKey.toString());

        DatabaseEvent snapshot = await queryRef.once();

        if (snapshot.snapshot.value != null) {
          Map<dynamic, dynamic>? data =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;

          if (data != null && data.isNotEmpty) {
            // Here, we assume that the query may return multiple products with the same Product_id.
            // If you expect only one result, you can access data.values.first directly.

            // Iterate through the results and update each product's Quantity
            data.forEach((productKey, productData) async {
              DatabaseReference productRef =
              dbref.ref().child("Product Details").child(productKey);

              int remainingStock =
                  int.parse(productData["Quantity"].toString()) -
                      item.quantity.value;
              // Update the 'Quantity' field in Firebase
              await productRef.update(
                  {'Quantity': remainingStock}); // Update Quantity to 100

              print("Updated data for Product_id ${item.firebaseKey}");
            });

            // Add product data to the productsData list for later use
            productsData.add({
              "name": item.name.toString(),
              "price": item.price,
              "quantity": item.quantity.value,
              // Add other relevant fields from your Product class
            });
          }
        } else {
          print("No data found for Product_id ${item.firebaseKey}");
        }
      }

      // Save the "Sells" data once, outside the loop
      await dbref.ref().child("Sells").push().set({
        "Sales_Serial": slnum,
        "Products": productsData,
        "CustomerName": Addproduct.CustomerName.value.toString(),
        "Subtotal": cart.totalAmount.toString(),
        "Discount": cart.discount.value,
        "DueAmount": cart.afterpaid.toString(),
        "paidAmount": cart.Paidammount.toString(),
        "Date": _dateFormat.format(_selectedDate).toString()
      });
      generatePDF;

    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<void> generatePDF(Map<String, dynamic> salesData, List<Map<String, dynamic>> productsData) async {
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text('Invoice', style: pw.TextStyle(
                  fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Customer Name: ${salesData["CustomerName"]}'),
              pw.Text('Sales Serial: ${salesData["Sales_Serial"]}'),
              pw.Text('Date: ${salesData["Date"]}'),
              pw.SizedBox(height: 20),
              pw.Text('Products:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.ListView.builder(
                itemCount: productsData.length,
                itemBuilder: (context, index) {
                  final product = productsData[index];
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(product["name"]),
                      pw.Text('Price: ${product["price"]} Tk'),
                      pw.Text('Quantity: ${product["quantity"]}'),
                    ],
                  );
                },
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text('Subtotal: ${salesData["Subtotal"]} Tk',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Discount: ${salesData["Discount"]}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text('Total: ${salesData["Subtotal"]} Tk',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Due Amount: ${salesData["DueAmount"]} Tk',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Text('Paid Amount: ${salesData["paidAmount"]} Tk',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );
  }


}
