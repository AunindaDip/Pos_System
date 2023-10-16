import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class saleslist extends StatefulWidget {
  const saleslist({super.key});
  @override
  State<saleslist> createState() => _saleslistState();
}

class _saleslistState extends State<saleslist> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref("Sells");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell List "),
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
                  List<dynamic> sells = [];
                  if (snapshot.data?.snapshot.value != null) {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as dynamic;
                    sells = map.values.toList();
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: sells.length,
                      itemBuilder: (context, int index) {
                        var saleData = sells[index];
                        var productsData = saleData['Products'];
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(5.0, 5.0), //(x,y)
                                    blurRadius: 8.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Customer Name : " +
                                            sells[index]['CustomerName'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Sl No :" +
                                            sells[index]['Sales_Serial'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Total Ammount :" +
                                            sells[index]['After Discount'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Text(
                                        "DATE :" + sells[index]['Date'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [

                                      const Text(
                                        "Invoice",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            genatateInvoice(
                                                productsData,
                                                sells[index]['Sales_Serial'],
                                                sells[index]['CustomerName'],
                                                sells[index]['Date'],
                                                sells[index]['Subtotal'],
                                                sells[index]['Discount'],
                                                sells[index]
                                                    ['After Discount'],
                                                sells[index]['paidAmount'],
                                                sells[index]['DueAmount']);

                                            final pdf = await genatateInvoice(
                                                productsData,
                                                sells[index]['Sales_Serial'],
                                                sells[index]['CustomerName'],
                                                sells[index]['Date'],
                                                sells[index]['Subtotal'],
                                                sells[index]['Discount'],
                                                sells[index]
                                                    ['After Discount'],
                                                sells[index]['paidAmount'],
                                                sells[index]['DueAmount']);

                                            final Uint8List pdfBytes = await pdf
                                                .save(); // Save the PDF to bytes
                                            await Printing.sharePdf(
                                              bytes:
                                                  pdfBytes, // Pass the bytes to sharePdf
                                              filename: 'invoice.pdf',
                                            );
                                          },
                                          icon: const Icon(
                                              color: Colors.green,
                                              Icons.picture_as_pdf))
                                    ],
                                  )
                                ]),
                              )),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Future<pw.Document> genatateInvoice(
      productsData,
      SerialNumm,
      CustomerName,
      selldate,
      subtotal,
      Discount,
      paidammount,
      afterdiscount,
      dueamount) async {
    final pdf = pw.Document();

    // Define a custom border style for lines
    const pw.Border customBorder = pw.Border(
      bottom: pw.BorderSide(
          color: PdfColors.black, width: 2), // Add a line at the bottom
      top: pw.BorderSide(
          color: PdfColors.black, width: 2), // Add a line at the top
      left: pw.BorderSide(
          color: PdfColors.black, width: 2), // Add a line on the left
      right: pw.BorderSide(
          color: PdfColors.black, width: 2), // Add a line on the right
    );

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Center(
                child: pw.Text('Invoice',
                    style: pw.TextStyle(
                        fontSize: 25, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Symbex International",
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800)),
              pw.Text("92 Motijheel Commercial Area, Dhaka:100",
                  style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Text("Phone: 01951135806, 9567758, 9550828",
                  style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Text("Email: symbex@dhaka.net",
                  style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Text("www.symbexbd.com",
                  style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
              pw.Container(
                height: 2, // Adjust the height of the line as needed
                color: PdfColors.black,
                margin: const pw.EdgeInsets.symmetric(
                    vertical: 5), // Adjust the vertical margin as needed
              ),
              pw.Text('Customer Name:' + CustomerName),
              pw.Text('Sales Serial: ' + SerialNumm),
              pw.Text('Date: ' + selldate),
              pw.SizedBox(height: 20),
              pw.Text('Products:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                child: pw.ListView.builder(
                  itemCount: productsData.length,
                  itemBuilder: (context, index) {
                    final product = productsData[index];
                    return pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: const pw.BoxDecoration(border: customBorder),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Text(product["name"]),
                          pw.Container(
                            width: 2, // Adjust the width of the line as needed
                            color: PdfColors.black,
                            height:
                                20, // Adjust the height of the line as needed
                          ),
                          pw.Text(
                            'Price: TK.${NumberFormat.currency(
                              decimalDigits: 2,
                              locale: "en-in",
                            ).format(double.parse(product["price"].toString())).replaceAll("INR", " ")}', // Parse the string to a double here
                          ),
                          pw.Container(
                            width: 2, // Adjust the width of the line as needed
                            color: PdfColors.black,
                            height:
                                20, // Adjust the height of the line as needed
                          ),
                          pw.Text('Quantity: ${product["quantity"]}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Text(
                      'Subtotal: TK.${NumberFormat.currency(
                        decimalDigits: 2,
                        locale: "en-in",
                      ).format(double.parse(subtotal.toString())).replaceAll("INR", " ")}', // Parse the string to a double here
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      'Discount: TK.${NumberFormat.currency(
                        decimalDigits: 2,
                        locale: "en-in",
                      ).format(double.parse(Discount.toString())).replaceAll("INR", " ")}', // Parse the string to a double here
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      'Total Amount: TK.${NumberFormat.currency(
                        decimalDigits: 2,
                        locale: "en-in",
                      ).format(double.parse(paidammount)).replaceAll("INR", " ")}', // Parse the string to a double here
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    'Paid Amount: TK.${NumberFormat.currency(
                      decimalDigits: 2,
                      locale: "en-in",
                    ).format(double.parse(afterdiscount.toString())).replaceAll("INR", " ")}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                      'Due Amount : TK.${NumberFormat.currency(
                        decimalDigits: 2,
                        locale: "en-in",
                      ).format(double.parse(dueamount.toString())).replaceAll("INR", " ")}', // Parse the string to a double here
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }
}
