import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos/HomePage.dart';
import 'package:get_storage/get_storage.dart';




class logIn extends StatefulWidget {
  const logIn({Key? key}) : super(key: key);

  @override
  _logInState createState() => _logInState();
}

class _logInState extends State<logIn> {
  late String _email, _password;
  final storage = GetStorage();


  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text("Products"),
        ),

        body: Container(

          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Your Email",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                ),
                SizedBox(height: 8),
                Text("Only Admin with Id Can Log in "),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_email.isNotEmpty && _password.isNotEmpty) {
                      try {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(child: CircularProgressIndicator());
                            });

                        final userCredential = await auth.signInWithEmailAndPassword(
                          email: _email,
                          password: _password,
                        );

                        final uid = userCredential.user!.uid;
                        _saveUserData(uid);

                        Navigator.of(context).pop();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        Fluttertoast.showToast(
                            msg: e.message!,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context).pop();
                      }
                    } else if (_email.isEmpty || _password.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "You Have to enter Both Email and Password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text('Log in'),
                )
              ],
            ),
          ),
        ));
  }
  void _saveUserData(String uid) {
    final userData = {
      'email': _email,
      'password': _password,
      'uid': uid,
    };

    storage.write('user_data', userData);
  }
}



