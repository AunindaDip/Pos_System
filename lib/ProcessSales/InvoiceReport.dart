import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:pos/Controller/cartcontroller.dart';
import 'package:pos/ProcessSales/ProductListFor_Invoice.dart';


class invoicereport extends StatefulWidget
{
  final String ? customerName, customerPhone;
  const invoicereport({super.key, this.customerName, this.customerPhone}); // Use '?' in constructor
  @override
  State<invoicereport> createState() => _invoicereportState(customerName, customerPhone);
}

class _invoicereportState extends State<invoicereport>
{
  _invoicereportState(customerName, customerPhone);

  final TextEditingController _customerNameController = TextEditingController(); // Create a TextEditingController
  DateTime _selectedDate = DateTime.now();
  DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final addproductcontroller Addproduct = Get.find<addproductcontroller>();
  final  CartController cart = Get.find<CartController>();





  /*@override
  void initState() {
    super.initState();
    _customerNameController.text = widget.customerName; // Set the initial value
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Generate Sales"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "",
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

                        text: _dateFormat.format(_selectedDate),// Display selected date
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
            height: 40,
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

          SizedBox(
            height: 20,
          ),
        cart.cartItems.isNotEmpty?
          Container(
            height: 200,
            child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index)
                {
                  return Container(
                    height: 20,
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(cart.cartItems[index].name.toString(),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),

                      ],
                    ),


                  );

                }),

          ):SizedBox.shrink(),










        ],
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose(); // Dispose of the controller
    super.dispose();
  }
}
