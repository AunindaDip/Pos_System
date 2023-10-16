import 'dart:ffi';
import 'dart:io' as io;
import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pos/HomePage.dart';
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
  BuildContext? _context;


  final dbref = FirebaseDatabase.instance;
  String pdfurl = " ";


  @override
  void initState() {

      loadcatagory();
      initialImageFile = file; // Set the initial image file
      _context = context;
      super.initState();









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
  File? initialImageFile; // Added to store the initial image file



  void loadcatagory() {
    Catgaoryconntroller.Catagorylist.clear();

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
    final picker = ImagePicker();

    try {
      final XFile? pickedFile = await showModalBottomSheet<XFile?>(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
                },
              ),
            ],
          );
        },
      );

      if (pickedFile != null) {
        final file = io.File(pickedFile.path);
        final compressedFile = await compressAndGetFile(file);

        setState(() {
          this.file = compressedFile;
        });
      }
    } catch (e) {
      print('Error selecting/capturing image: $e');
    }
  }
  Future<File?> compressAndGetFile(File file) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.absolute.path}_compressed.jpg',
      quality: 50, // Adjust the compression quality as needed (0 to 100)
    );

    return result;
  }

  Future<String?> uploadPdf(String filename, File file) async {
    showProgressDialog(context); // Show the progress dialog

    final reference = FirebaseStorage.instance.ref().child("catalog/$filename.pdf");

    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() => {});

    var downloadlink = await reference.getDownloadURL();
    Navigator.of(context, rootNavigator: true).pop(); // Close the progress dialog

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
        pdfurl = downloadlink ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            clearFieldsAndNavigate();
/*
            Navigator.pop(context); // U
*/
            Get.back(); // Use Get.back() to navigate back

            // Handle back button press here

          },
        ),

      ),
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
                          child:DropdownButton<catagorymodel>(
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
                const SizedBox(
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
                      if (file == null || pdfurl == " ") {
                        Fluttertoast.showToast(
                          msg: 'Please select an image and catalog',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      } else if (productname.text.isEmpty ||
                          productdescription.text.isEmpty ||
                          buyingprice.text.isEmpty ||
                          sellingprice.text.isEmpty ||
                          quantity.text.isEmpty ||
                          selectedCategory == null) {
                        Fluttertoast.showToast(
                          msg: 'Please fill in all the required fields',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        Catgaoryconntroller.addproductbool.value = true;
                        Future.delayed(const Duration(seconds: 2), () {
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
                        ? const Text("Save")
                        : const Text("Save")),

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
      child: SizedBox(
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

 savetodatabase(
      TextEditingController productname,
      TextEditingController productdescription,
      catagorymodel selectedcategory,
      TextEditingController buyingprice,
      TextEditingController sellingprice,
      TextEditingController quantity) async {

      try {
        final compressedFile = await compressAndGetFile(file!);

        var imagefile = FirebaseStorage.instance
            .ref()
            .child("product_photo")
            .child("/${productname.text}.jpg");
        UploadTask task = imagefile.putFile(compressedFile!);
        TaskSnapshot snapshot = await task;
        url = await snapshot.ref.getDownloadURL();

          url = url;


        if (url != null) {
          int otp = Random().nextInt(9999);
          int noOfOtpDigit = 4;
          while (otp.toString().length != noOfOtpDigit)
          {
            otp = Random().nextInt(9999);
          }
          String otpString = otp.toString();

          dbref.ref().child("Product Details").push().set({
            "Name": productname.text.toString(),
            "Description": productdescription.text.toString(),
            "Category": selectedcategory.Name.toString(),
            "buying-price": buyingprice.text.toString(),
            "Selling price": sellingprice.text.toString(),
            "Quantity": quantity.text.toString(),
            "url": url.toString(),
            "pdfurl": pdfurl.toString(),
            "Product_id": otpString
          });



          clearFieldsAndNavigate();
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


   clearFieldsAndNavigate()async {
    // Clear form fields
    productname.clear();
    productdescription.clear();
    selectedCategory = null;
    buyingprice.clear();
    sellingprice.clear();
    quantity.clear();
    file = null; // Set the image file to null or default state
    pdfurl = " ";
    Catgaoryconntroller.selectedpdf.value='Upload Catalog';// S
/*
    Catgaoryconntroller.Catagorylist.clear();// et the PDF URL to null or default state
*/


  }
  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog by tapping outside
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Uploading Catalog..."),
              ],
            ),
          ),
        );
      },
    );
  }



}

