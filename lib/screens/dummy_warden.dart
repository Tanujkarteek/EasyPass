// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:easypass/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DWardPage extends StatelessWidget {
  const DWardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color.fromRGBO(0, 146, 121, 1),
          //     Color.fromRGBO(173, 224, 129, 1)
          //   ],
          // ),
          color: Color.fromRGBO(30, 30, 30, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              style: TextStyle(
                color: Color.fromRGBO(14, 183, 145, 1),
                fontFamily: "ShoraiSans",
                fontSize: 48,
              ),
              textAlign: TextAlign.center,
              "Dummy Warden Page",
            ),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size.fromHeight(50),
            //   ),
            //   icon: Icon(Icons.logout),
            //   label: Text("Logout"),
            //   onPressed: () => {
            //     Navigator.popAndPushNamed(context, '/welcome'),
            //     FirebaseAuth.instance.signOut(),
            //   },
            // )
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
                    Color.fromRGBO(0, 0, 0, 1),
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
