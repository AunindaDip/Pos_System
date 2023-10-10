import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pos/Controller/CatagoryController.dart';
import 'package:pos/Controller/LogINController.dart';
import 'package:pos/Controller/addproduct.dart';
import 'package:pos/Controller/cartcontroller.dart';
import 'package:pos/HomePage.dart';
import 'package:pos/Log-In.dart';
import 'package:pos/firebase_options.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(addproductcontroller());
  Get.put(CartController());
  Get.put(logInController());
  Get.put(catagorycontroller());


  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _loadUserData();

    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? MyHomePage() : const LoginScreen(),
    );
  }

  bool _loadUserData() {
    final userData = GetStorage().read('user_data');
    if (userData == null) {


        return false; // User is logged in, navigate to the homepage
      }
    else{
      return true;
    }
    }
     // User is not logged in, navigate to the login page
  }


