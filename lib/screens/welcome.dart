// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:easypass/components/vectoreasset.dart';
import 'package:easypass/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatelessWidget {
  static const routeName = '/welcome';
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // SvgPicture.asset(
          //   bgimg,
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),
          Container(
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color.fromRGBO(44, 224, 171, 1),
              //     Color.fromRGBO(59, 190, 221, 1)
              //   ],
              // ),
              color: Color.fromRGBO(30, 30, 30, 1),
              // image: DecorationImage(
              //   image: AssetImage("assets/images/bgimg.png"),
              //   fit: BoxFit.fill,
              // ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Text(
                        "EasyPass",
                        style: TextStyle(
                          //color: Colors.black,
                          color: Color.fromRGBO(14, 183, 145, 1),
                          fontFamily: "ShoraiSans",
                          fontSize: 48,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
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
                              //Colors.black,
                              Color.fromRGBO(14, 183, 145, 1),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIN()));
                          },
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }
}
