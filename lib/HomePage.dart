import 'package:flutter/material.dart';
import 'package:pos/Addproduct.dart';
import 'package:get/get.dart';
import 'package:pos/Catatgories.dart';
import 'package:pos/Customer/CreatCustomer.dart';
import 'package:pos/ListofSales.dart';
import 'package:pos/Log-In.dart';
import 'package:pos/ProcessSales/Sales.dart';
import 'package:pos/ViewProduct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<void Function()> buttonFunctions;
  @override
  void initState() {
    super.initState();
    buttonFunctions = [
      () {
        Get.to(() => const addcatagory(), transition: Transition.leftToRight);
      },
      () {},
      () {
        Get.to(() => viewproduct(), transition: Transition.leftToRight);
      },
      () {
        _signOut();
      },
    ];
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Clear any saved user data if needed
      GetStorage().remove('user_data');
      // Navigate back to the login page
      Get.offAll(logIn());
    } catch (e)
    {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Point of Sale ")),
        ),
        body: Column(

          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                _buildCustomButton(
                  image: "lib/assets/Images/catagory.png",
                  text: "Add Category",
                  color: const Color.fromRGBO(208, 242, 230, 1),
                  onTap: () {
                    Get.to(() => const addcatagory(),
                        transition: Transition.leftToRight);
                    //...
                  },
                ),


                _buildCustomButton(
                  image: "lib/assets/Images/add1.jpg",
                  text: "Add Product",
                  color: const Color.fromRGBO(242, 223, 228, 1.0),
                  onTap: () {
                    Get.to(() => const addproduct(),
                        transition: Transition.leftToRight);
                    //...
                  },
                ),


                _buildCustomButton(
                  image: "lib/assets/Images/Viewproduct.png",
                  text: "View Products",
                  color: const Color.fromRGBO(174, 171, 245, 1.0),
                  onTap: () {
                    Get.to(() => const viewproduct(),
                        transition: Transition.leftToRight);
                    //...
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomButton(
                  image: "lib/assets/Images/Addcustomer.png",
                  text: "Add Customer",
                  color: const Color.fromRGBO(162, 242, 170, 1),
                  onTap: () {
                    Get.to(() => const creatCustomer(),
                        transition: Transition.leftToRight);
                    //...
                  },
                ),
                _buildCustomButton(
                  image: "lib/assets/Images/Sales.png",
                  text: "Sales",
                  color: const Color.fromRGBO(240, 200, 127, 1.0),
                  onTap: () {

                    Get.to(() =>  sales(),
                        transition: Transition.leftToRight);

                    //...
                  },
                ),
                _buildCustomButton(
                  image: "lib/assets/Images/Signout.png",
                  text: "Sign Out",
                  color: const Color.fromRGBO(212, 119, 181, 1.0),
                  onTap: () {
                    _signOut();
                  },
                ),



              ],
            ),

            Row(
              children: [
                _buildCustomButton(
                  image: "lib/assets/Images/sign.png",
                  text: "All Sales",
                  color: const Color.fromRGBO(114, 146, 166, 1.0),
                  onTap: () {
                    Get.to(() =>  saleslist(),
                        transition: Transition.leftToRight);

                  },
                ),



              ],
            )


          ],





        )


    );
  }
}
Widget _buildCustomButton({
  required String image,
  required String text,
  required Color color,
  required void Function() onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 140,
          width: 120,
          decoration: BoxDecoration(color: color),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                image,
                height: 60,
                width: 60,
                fit: BoxFit.contain,
              ),
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

