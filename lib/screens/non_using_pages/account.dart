// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:easypass/components/frostedglass.dart';
import '../non_using_pages/signin_war_guar.dart';
import 'package:easypass/screens/signin.dart';
import 'package:flutter/material.dart';

class AccType extends StatelessWidget {
  const AccType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
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
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                  FrostedGlassBox(
                    theWidth: MediaQuery.of(context).size.width * 0.85,
                    theHeight: MediaQuery.of(context).size.height * 0.50,
                    theChild: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              "Choose Account type",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Cascadia",
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
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
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignIN()));
                              },
                              child: Text(
                                "Student",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
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
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WarGSIn()));
                              },
                              child: Text(
                                "Warden",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
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
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WarGSIn()));
                              },
                              child: Text(
                                "Guard",
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
