import 'dart:io' as io;
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Modelclass/catagorymodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class addproduct extends StatefulWidget {
  const addproduct({super.key});
  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  final addproductcontroller Catgaoryconntroller =
      Get.find<addproductcontroller>();

  final dbref = FirebaseDatabase.instance;
  String pdfurl = " ";

  @override
  void initState() {
    super.initState();
    loadcatagory();
  }

  List<String> categoryList = [];
  List<DropdownMenuItem<String>> dropdownItems = [];
  catagorymodel? selectedCategory;
  ImagePicker image = ImagePicker();
  var url;

  TextEditingController productname = TextEditingController();
  TextEditingController productdescription = TextEditingController();
  TextEditingController catagorycontroll = TextEditingController();
  TextEditingController buyingprice = TextEditingController();
  TextEditingController sellingprice = TextEditingController();
  TextEditingController quantity = TextEditingController();
  String defaultImagePath =
      'lib/assets/Images/add_Pice.jpg'; // Use the actual asset path

  File? file;
  String selectedPdfName = "Catalog";

  void loadcatagory() {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('Category');

    databaseRef.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Map<dynamic, dynamic>? snapshotValue =
            databaseEvent.snapshot.value as Map<dynamic, dynamic>?;

        if (snapshotValue != null) {
          snapshotValue.forEach((key, value) {
            String? name = value['Name'];

            if (name != null && Catgaoryconntroller.Catagorylist != null) {
              Catgaoryconntroller.Catagorylist.add(
                catagorymodel(Name: name),
              );
            }
          });
        }
      }
    }).catchError((error) {
      // Handle error if database fetch fails
    });
  }

  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = io.File(image.path);
      final compressedFile = await compressAndGetFile(file);

      setState(() {
        this.file = file;
      });
    }
  }

  Future<File?> compressAndGetFile(File file) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.absolute.path + '_compressed.jpg',
      quality: 50, // Adjust the compression quality as needed (0 to 100)
    );

    return result;
  }

  Future<String?> uploadPdf(String filename, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("catalog/$filename.pdf");

    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() => {});

    var downloadlink = await reference.getDownloadURL();

    return downloadlink;
  }

  Future<void> pickFile() async {
    final pickedfile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedfile != null) {
      String fileName = pickedfile.files[0].name;
      File file = File(pickedfile.files[0].path!);

      var downloadlink = await uploadPdf(fileName, file);
      setState(() {
        selectedPdfName = fileName;
        Catgaoryconntroller.selectedpdf.value = fileName;

        pdfurl = downloadlink ?? ""; //
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "ADD Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child:
                      buildImageWidget(file), // Use the buildImageWidget here
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: productname,
                    decoration: const InputDecoration(
                        hintText: "Product Name",
                        labelText: "Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: productdescription,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Description",
                        labelText: "Product Description",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: DropdownButton<catagorymodel>(
                            elevation: 5,
                            isExpanded: true,
                            isDense: true,
                            hint: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Select Category",
                              ),
                            ),
                            value: selectedCategory,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                            ),
                            iconSize: 36,
                            items: Catgaoryconntroller.Catagorylist.map<
                                DropdownMenuItem<catagorymodel>>(
                              (category) {
                                return DropdownMenuItem<catagorymodel>(
                                  value: category,
                                  child: Text(category.Name),
                                );
                              },
                            ).toList(),
                            onChanged: (catagorymodel? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: quantity,
                    decoration: const InputDecoration(
                        hintText: "Product Quantity ",
                        labelText: "Quantity",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: MaterialButton(
                      onPressed: () {
                        pickFile();
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Adjust padding here

                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Catgaoryconntroller.selectedpdf.obs.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: buyingprice,
                          decoration: const InputDecoration(
                              hintText: "Amount",
                              labelText: "Buying price",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2),
                              ),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: sellingprice,
                          decoration: const InputDecoration(
                              hintText: "Selling price",
                              labelText: "Amount",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2),
                              ),
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (productname.text.isEmpty ||
                          productdescription.text.isEmpty ||
                          buyingprice.text.isEmpty ||
                          sellingprice.text.isEmpty ||
                          quantity.text.isEmpty ||
                          selectedCategory == null ||
                          pdfurl.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please enter both mobile and password',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        Catgaoryconntroller.addproductbool.value = true;
                        Future.delayed(Duration(seconds: 2), () {
                          savetodatabase(
                            productname,
                            productdescription,
                            selectedCategory!,
                            buyingprice,
                            sellingprice,
                            quantity,
                          ).then((_) {
                            // Close the loading screen when the saving is complete
                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        });
                      }
                    },
                    child: Catgaoryconntroller.addproductbool.value
                        ? Text("Save")
                        : Text("Save")),
                if (Catgaoryconntroller.addproductbool.value)
                  ModalBarrier(
                    color: Colors.black.withOpacity(0.5),
                    dismissible: false,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageWidget(io.File? file) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: double.infinity,
        child: MaterialButton(
          height: 100,
          child: file != null
              ? Image.file(
                  file,
                  fit: BoxFit.fill,
                )
              : Image.asset(
                  defaultImagePath,
                  fit: BoxFit.fill,
                ),
          onPressed: () {
            getImage();
          },
        ),
      ),
    );
  }

  Future<void> savetodatabase(
      TextEditingController productname,
      TextEditingController productdescription,
      catagorymodel selectedcategory,
      TextEditingController buyingprice,
      TextEditingController sellingprice,
      TextEditingController quantity) async {
    if (file == null || Catgaoryconntroller.selectedpdf.value == "Catalog") {
      Fluttertoast.showToast(
        msg: 'helolo',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      try {
        final compressedFile = await compressAndGetFile(file!);

        var imagefile = FirebaseStorage.instance
            .ref()
            .child("product_photo")
            .child("/${productname.text}.jpg");
        UploadTask task = imagefile.putFile(compressedFile!);
        TaskSnapshot snapshot = await task;
        url = await snapshot.ref.getDownloadURL();
        setState(() {
          url = url;
        });

        if (url != null) {
          dbref.ref().child("Product Details").push().set({
            "Name": productname.text.toString(),
            "Description": productdescription.text.toString(),
            "Category": selectedcategory.Name.toString(),
            "buying-price": buyingprice.text.toString(),
            "Selling price": sellingprice.text.toString(),
            "Quantity": quantity.text.toString(),
            "url": url.toString(),
            "pdfurl": pdfurl.toString()
          });

          productname.clear();
          productdescription.clear();
          buyingprice.clear();
          sellingprice.clear();
          quantity.clear();
          Catgaoryconntroller.selectedpdf.value = "Upload Catalog";

          Catgaoryconntroller.addproductbool.value = false;

          Fluttertoast.showToast(
            msg: 'Data saved successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } on Exception catch (e) {
        Catgaoryconntroller.addproductbool.value = false;

        print(e);
      }
    }
  }
}
