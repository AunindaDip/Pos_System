import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos/test.dart';
import 'package:intl/intl.dart';

class viewproduct extends StatefulWidget {
  const viewproduct({super.key});

  @override
  State<viewproduct> createState() => _viewproductState();
}

class _viewproductState extends State<viewproduct> {
  final ref = FirebaseDatabase.instance.ref("Product Details");
  bool _isLoading = false;

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
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black87),
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
                                      SizedBox(
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
                                        "Catalouge",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange)
                                        ,
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            String pdfUrl = products[index]
                                                    ['pdfurl']
                                                .toString();
                                            await _downloadAndViewPDF(pdfUrl);
                                          },
                                          icon: Icon(
                                              color: Colors.deepOrange,

                                              Icons.picture_as_pdf_rounded))
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

  Future<void> _downloadAndViewPDF(String pdfUrl) async {
    if (await _requestStoragePermission()) {
      try {
        // Set the _isLoading flag to true when the PDF download starts
        setState(() {
          _isLoading = true;
        });

        final response = await http.get(Uri.parse(pdfUrl));
        final tempDir = await getTemporaryDirectory();
        final file = File("${tempDir.path}/pdf.pdf");
        await file.writeAsBytes(response.bodyBytes);

        String localPath = file.path;
        Get.to(() => PDFScreen1(path: localPath),
            transition: Transition.leftToRight);
      } catch (error) {
        print('Error downloading PDF: $error');
        // Show an error message or take appropriate action.
      } finally {
        // Set the _isLoading flag back to false when the PDF download is complete
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Show an error message or take appropriate action.
    }
  }

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
