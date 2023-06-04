// ignore_for_file: prefer_const_constructors

import 'package:easypass/screens/scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/frostedglass.dart';

class GuardDash extends StatefulWidget {
  const GuardDash({Key? key}) : super(key: key);

  @override
  State<GuardDash> createState() => _GuardDashState();
}

class _GuardDashState extends State<GuardDash> {
  bool isContentVisible = true;

  void toggleContentVisibility() {
    setState(() {
      isContentVisible = !isContentVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
        child: FloatingActionButton(
          elevation: 10.0,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScannerPage(),
            ),
          ),
          backgroundColor: Color.fromRGBO(14, 183, 145, 1),
          child: Icon(
            Icons.qr_code_scanner_rounded,
            size: MediaQuery.of(context).size.width * 0.08,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: Color.fromRGBO(30, 30, 30, 1),
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: RichText(
            text: TextSpan(
              children: const <TextSpan>[
                TextSpan(
                  text: 'Hi, ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: "Tanuj",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              Navigator.popAndPushNamed(context,
                  '/welcome'), // have to change this to profile page asap
              FirebaseAuth.instance.signOut(),
            },
            icon: Icon(
              Icons.circle,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.18,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.12,
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [Color(0xff009279), Color(0xffADE081)],
              //   begin: FractionalOffset(1.0, 0.0),
              //   end: FractionalOffset(0.0, 1.0),
              // ),
              color: Color.fromRGBO(30, 30, 30, 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Active Outpass',
                              style: TextStyle(
                                color: Color.fromRGBO(14, 183, 145, 1),
                                fontSize: 28,
                                fontFamily: 'Cascadia',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: toggleContentVisibility,
                    child: isContentVisible
                        ? FrostedGlassBox(
                            theHeight: 260.00,
                            theWidth: MediaQuery.of(context).size.width * 0.9,
                            theChild: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Outpass #',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "1",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    RichText(
                                      text: TextSpan(
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Pala,IN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Cascadia',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Name: ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                      text: 'Tanuj Karteek Allena',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                                  ],
                                ),
                                // Container(
                                //   width: MediaQuery.of(context).size.width * 0.6,
                                //   child: Image.asset(
                                //     'assets/images/qrcode_1.png',
                                //     fit: BoxFit.contain,
                                //   ),
                                // ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Time Left: ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'XX',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.005),
                                          ),
                                          TextSpan(
                                            text: 'h',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                          ),
                                          TextSpan(
                                            text: 'XX',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.005),
                                          ),
                                          TextSpan(
                                            text: 'm',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                          ),
                                          TextSpan(
                                            text: 'XX',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.005),
                                          ),
                                          TextSpan(
                                            text: 's',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            children: const <TextSpan>[
                                              TextSpan(
                                                text: 'From: ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'XX',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01),
                                              ),
                                              TextSpan(
                                                text: ':',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01)),
                                              TextSpan(
                                                text: 'XX',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.005)),
                                              TextSpan(
                                                text: 'am',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            children: const <TextSpan>[
                                              TextSpan(
                                                text: 'To: ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'XX',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01),
                                              ),
                                              TextSpan(
                                                text: ':',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01)),
                                              TextSpan(
                                                text: 'XX',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.005)),
                                              TextSpan(
                                                text: 'pm',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                            children: const <TextSpan>[
                                              TextSpan(
                                                text: 'Approved by: ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: const [
                                              TextSpan(
                                                text: 'Dr.Bhanu',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : FrostedGlassBox(
                            theHeight: 260.00,
                            theWidth: MediaQuery.of(context).size.width * 0.9,
                            theChild: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Outpass #',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "1",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    RichText(
                                      text: TextSpan(
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Pala,IN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Cascadia',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: const <TextSpan>[
                                          TextSpan(
                                            text: 'Name: ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                      text: 'Tanuj Karteek Allena',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                                  ],
                                ),
                                // Container(
                                //   width: MediaQuery.of(context).size.width * 0.6,
                                //   child: Image.asset(
                                //     'assets/images/qrcode_1.png',
                                //     fit: BoxFit.contain,
                                //   ),
                                // ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromRGBO(14, 183, 145, 1)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: null,
                                    child: Text(
                                      "Notify for Return",
                                      style: TextStyle(
                                        color: Color.fromRGBO(30, 30, 30, 1),
                                        fontSize: 16,
                                        fontFamily: 'Cascadia',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
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
