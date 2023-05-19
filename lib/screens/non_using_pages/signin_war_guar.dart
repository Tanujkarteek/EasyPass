// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../../components/frostedglass.dart';

class WarGSIn extends StatefulWidget {
  const WarGSIn({super.key});

  @override
  State<WarGSIn> createState() => _StudSIState();
}

class _StudSIState extends State<WarGSIn> {
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 8, bottom: 8),
                                  child: TextField(
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
                                        hintText: "Name"),
                                  ),
                                )),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  child: TextField(
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
                                          onPressed: () {},
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
                                              color:
                                                  Color.fromRGBO(0, 27, 45, 1),
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
}
