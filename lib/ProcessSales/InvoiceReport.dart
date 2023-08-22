
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:pos/Controller/cartcontroller.dart';
import 'package:pos/ProcessSales/ProductListFor_Invoice.dart';
import 'package:firebase_database/firebase_database.dart';

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
  int _invoiceNumber = 0; // Initialize with a default value
  final ref = FirebaseDatabase.instance.ref("Product Details");
  final TextEditingController _customerNameController = TextEditingController(); // Create a TextEditingController
  DateTime _selectedDate = DateTime.now();
  DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final addproductcontroller Addproduct = Get.find<addproductcontroller>();
  final CartController cart = Get.find<CartController>();









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
                          hintText:_invoiceNumber.toString(),
                          labelText: "Inv No.",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                          border: OutlineInputBorder()),
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
                          border: OutlineInputBorder(),
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
            cart.cartItems.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 160,
                child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              cart.cartItems[index].name.toString(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (cart.cartItems[index].quantity.value >
                                  1) {
                                cart.cartItems[index].quantity.value--;
                              }
                            },
                          ),
                          Obx(() => Text(
                            cart.cartItems[index].quantity.value
                                .toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (cart.cartItems[index].quantity.value <
                                  cart.cartItems[index].stock.value) {
                                cart.cartItems[index].quantity.value++;
                              }
                            },
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => Text(
                              (cart.cartItems[index].quantity.value *
                                  cart.cartItems[index].price)
                                  .toString() +
                                  ("0Tk"),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        ],
                      );
                    }),
              ),
            )
                : const SizedBox.shrink(),
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
                              onChanged: (value) {
                                cart.discount=RxDouble(double.parse(value));
                                cart.setDiscount(cart.discount.value);
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
                        children:  [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(() => Text(
                            cart.afterdiscount.toString().isEmpty
                                ? "0.00Tk."
                                : "${cart.totalAmount}Tk.",
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
                                hintText: 'Enter discount',
                                // Other decoration properties like borders, icons, etc.
                              ),
                              onChanged: (value) {
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
                        children: const [
                          Text(
                            "Due Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Text(
                            "15000Tk.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Proceed Sell"))
          ],
        ),
      ),
    );
  }}