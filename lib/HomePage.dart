import 'package:flutter/material.dart';
import 'package:pos/Addproduct.dart';
import 'package:get/get.dart';
import 'package:pos/Catatgories.dart';
import 'package:pos/Customer/CreatCustomer.dart';
import 'package:pos/Log-In.dart';
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
        print('Button 1 pressed!');
      },
          () {

      },
          () {
        Get.to(() => viewproduct(), transition: Transition.leftToRight);
        print('Button 3 pressed!');
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
    } catch (e) {
      print("Error signing out: $e");
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
            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                Container(
                  height: 140,
                  width: 100,
                  decoration: const BoxDecoration(

                    image: DecorationImage(
                      image: AssetImage('lib/assets/Images/add1.jpg'),
                      fit: BoxFit.fill//
                      // Replace with your asset image path

                    ),
                  ),
                  child: ElevatedButton(onPressed: ()
                  {Get.to(() => const addcatagory(), transition: Transition.leftToRight);},
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>
                      ( Color.fromRGBO(208, 242, 230,1)),),
                      child: Text(
                        "Add Catagory",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                        ,),
                  )
                  ,)
                ,
                SizedBox(
                  width: 10,
                ),


                Container(
                  height: 140,
                  width: 100,
                  decoration: BoxDecoration(
                  ),
                  child: ElevatedButton(onPressed: ()
                  {
                    Get.to(() => const addproduct(), transition: Transition.leftToRight);




                  },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(242, 223, 228,1.0), // Cream color with RGB value of (164, 178, 245)
                        ),
                      ),


                      child: Text("Add product",style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),)),
                ),

                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 140,
                  width: 100,
                  decoration: BoxDecoration(
                  ),
                  child: ElevatedButton(onPressed: ()
                  {
                    Get.to(() => viewproduct(), transition: Transition.leftToRight);

                  },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(174, 171, 245,1.0), // Cream color with RGB value of (164, 178, 245)
                        ),
                      ),


                      child: Text("View Products",style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold),)),
                ),

              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 140,
                  width: 100,
                  decoration: BoxDecoration(
                  ),
                  child: ElevatedButton(onPressed: ()
                  {
                    _signOut();

                  },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(174, 171, 245,1.0), // Cream color with RGB value of (164, 178, 245)
                        ),
                      ),


                      child: Text("Sign Out",style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold),)),
                ),
                SizedBox(
                  width:10 ,
                ),
                Container(
                  height: 140,
                  width: 100,
                  decoration: BoxDecoration(
                  ),
                  child: ElevatedButton(onPressed: ()
                  {
                    Get.to(() => const creatCustomer(), transition: Transition.leftToRight);

                  },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(195, 250, 245,1.0), // Cream color with RGB value of (164, 178, 245)
                        ),
                      ),


                      child: const Text("Create Customer",style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold),)),
                ),





              ],
            ),



          ],
        ));
  }




}


