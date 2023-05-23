// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, annotate_overrides, use_build_context_synchronously, unused_import, unused_local_variable

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easypass/screens/dummy_guard.dart';
import 'package:easypass/screens/dummy_warden.dart';
import 'package:easypass/screens/stud_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/frostedglass.dart';
import 'dummy_stud.dart';

class SignIN extends StatefulWidget {
  const SignIN({super.key});

  @override
  State<SignIN> createState() => _SingINState();
}

class _SingINState extends State<SignIN> {
  var role_type;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 146, 121, 1),
                    Color.fromRGBO(173, 224, 129, 1)
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // height:  MediaQuery.of(context).size.width,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        Text(
                          "EasyPass",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 27, 45, 1),
                            fontFamily: "ShoraiSans",
                            fontSize: 48,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.23,
                        ),
                        FrostedGlassBox(
                          theWidth: MediaQuery.of(context).size.width * 0.85,
                          theHeight: MediaQuery.of(context).size.height * 0.4,
                          theChild: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30,
                                          right: 30,
                                          top: 8,
                                          bottom: 8),
                                      child: TextFormField(
                                        controller: emailController,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                        ),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Color.fromRGBO(0, 27, 45, 1),
                                          filled: true,
                                          focusColor:
                                              Color.fromRGBO(0, 53, 88, 0.294),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Montserrat"),
                                          hintText: "Email Address",
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter an email address';
                                          }
                                          if (!_validateEmail(value)) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 30,
                                      right: 30,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Montserrat",
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        fillColor: Color.fromRGBO(0, 27, 45, 1),
                                        filled: true,
                                        focusColor:
                                            Color.fromRGBO(0, 53, 88, 0.294),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Montserrat"),
                                        hintText: "Password",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter the password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 3, right: 132),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    173, 224, 129, 1),
                                                fontSize: 15,
                                                fontFamily: "Montserrat",
                                              ),
                                              text: ("Forget password?"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 1, top: 14),
                                      child: Column(
                                        //crossAxisAlignment:CrossAxisAlignment.end,
                                        children: <Widget>[
                                          ElevatedButton(
                                            //onPressed: signIN,
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                signIN();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromRGBO(
                                                  173, 224, 129, 1),
                                              padding: const EdgeInsets.only(
                                                  left: 45,
                                                  right: 45,
                                                  top: 10,
                                                  bottom: 10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14.0)),
                                            ),
                                            child: const Text(
                                              'Sign in',
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 25,
                                                color: Color.fromRGBO(
                                                    0, 27, 45, 1),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    //print(user!.uid);
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "warden") {
          role_type = "warden";
          saveUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DWardPage(),
            ),
          );
        } else if (documentSnapshot.get('role') == "student") {
          role_type = "student";
          saveUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudDash(),
            ),
          );
        } else if (documentSnapshot.get('role') == "guard") {
          role_type = "guard";
          saveUser();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DGuardPage(),
            ),
          );
        }
      } else {
        AnimatedSnackBar.material(
          'Document does not exist on the database',
          type: AnimatedSnackBarType.error,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
      }
    });
  }

  Future signIN() async {
    // await FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: emailController.text.trim(),
    //   password: passwordController.text.trim(),
    // );
    // route();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      route();
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Error signing in. Please try again later.';
      }

      AnimatedSnackBar.material(
        errorMessage,
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
    } catch (e) {
      AnimatedSnackBar.material(
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
    }
  }

  Future<void> saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('type', role_type);
  }
}
