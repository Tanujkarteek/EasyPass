// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:easypass/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DGuardPage extends StatelessWidget {
  const DGuardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              style: TextStyle(
                color: Color.fromRGBO(0, 27, 45, 1),
                fontFamily: "ShoraiSans",
                fontSize: 48,
              ),
              textAlign: TextAlign.center,
              "Dummy Guard Page",
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromRGBO(0, 27, 45, 1),
                  ),
                ),
                onPressed: () => {
                  Navigator.popAndPushNamed(context, '/welcome'),
                  FirebaseAuth.instance.signOut(),
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
