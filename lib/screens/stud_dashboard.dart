// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/frostedglass.dart';
import 'package:easypass/screens/outpass_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudDash extends StatefulWidget {
  const StudDash({super.key});

  @override
  State<StudDash> createState() => _StudDashState();
}

class _StudDashState extends State<StudDash> {
  String qrdata = 'No Data';
  String qrdataup = 'No Data';
  String safeQrDataActive = 'No Data';
  String safeQrDataPending = 'No Data';
  Future<void> callActiveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // take snapshot of the documents froms logs collection with field status set to active
    var data = await FirebaseFirestore.instance
        .collection('logs')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'approved')
        .where('isScanned', isEqualTo: 'yes')
        .get();
    // now set qrdata to the value of the field outpass_id of the first document in the snapshot
    //print(data.docs[0]['outpassId']);
    setState(() {
      qrdata = data.docs[0]['outpassId'];
      safeQrDataActive = qrdata;
    });
  }

  Future<void> callPendingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // take snapshot of the documents froms logs collection with field status set to active
    var data = await FirebaseFirestore.instance
        .collection('logs')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'approved')
        .where('isScanned', isEqualTo: 'no')
        .get();
    // now set qrdata to the value of the field outpass_id of the first document in the snapshot
    //print(data.docs[0]['outpassId']);
    setState(() {
      qrdataup = data.docs[0]['outpassId'];
      safeQrDataPending = qrdataup;
    });
  }

  @override
  void initState() {
    super.initState();

    // Call your function here
    getQR();
  }

  void getQR() {
    callPendingData();
    callActiveData();
    //return safeQrData;
  }

  //make this qrdata var null safe
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
              builder: (context) => RequestPage(),
            ),
          ),
          backgroundColor: Color.fromRGBO(14, 183, 145, 1),
          child: Icon(
            Icons.add,
            size: MediaQuery.of(context).size.width * 0.1,
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
              // image: DecorationImage(
              //   image: AssetImage("assets/images/bgimg.png"),
              //   fit: BoxFit.fill,
              // ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Row(
                  //     children: <Widget>[
                  //       SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.05,
                  //       ),
                  //       RichText(
                  //         text: TextSpan(
                  //           children: const <TextSpan>[
                  //             TextSpan(
                  //               text: 'Hi, ',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 30,
                  //                 fontFamily: 'Montserrat',
                  //                 fontWeight: FontWeight.w400,
                  //               ),
                  //             ),
                  //             TextSpan(
                  //               text: "Tanuj",
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 30,
                  //                 fontFamily: 'Montserrat',
                  //                 fontWeight: FontWeight.w800,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       // GestureDetector(
                  //       //   onTap: () {
                  //       //     Fluttertoast.showToast(
                  //       //       toastLength: Toast.LENGTH_SHORT,
                  //       //       gravity: ToastGravity.BOTTOM,
                  //       //       msg: "App is still under works",
                  //       //     );
                  //       //   },
                  //       //   child: SvgPicture.asset(
                  //       //     searchicon,
                  //       //     height: 40,
                  //       //     width: 40,
                  //       //   ),
                  //       // ),
                  //       SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.04,
                  //       ),
                  //       CircleAvatar(
                  //         radius: 25,
                  //         // backgroundImage: AssetImage(
                  //         //   'assets/images/Grabify_Logo_final.png',
                  //         // ),
                  //         backgroundColor: Colors.white,
                  //       ),
                  //       SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.05,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FrostedGlassBox(
                        theHeight: MediaQuery.of(context).size.height * 0.54,
                        theWidth: MediaQuery.of(context).size.width * 0.9,
                        theChild: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            // ignore: sized_box_for_whitespace
                            // Container(
                            //   width: MediaQuery.of(context).size.width * 0.6,
                            //   child: Image.asset(
                            //     'assets/images/qrcode_1.png',
                            //     fit: BoxFit.contain,
                            //   ),
                            // ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                ),
                                PrettyQr(
                                  size: MediaQuery.of(context).size.width * 0.5,
                                  //make data qrdata or something else so that is null safe
                                  data: safeQrDataActive,
                                  //data: qrdata,
                                  errorCorrectLevel: QrErrorCorrectLevel.M,
                                  roundEdges: true,
                                  typeNumber: 5,
                                  elementColor: Colors.black,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
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
                              height: MediaQuery.of(context).size.height * 0.01,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        children: [
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
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
                              text: 'Upcoming Outpass',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FrostedGlassBox(
                        //theHeight: 460.00,
                        theHeight: MediaQuery.of(context).size.height * 0.54,
                        theWidth: MediaQuery.of(context).size.width * 0.9,
                        theChild: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            // ignore: sized_box_for_whitespace
                            // Container(
                            //   width: MediaQuery.of(context).size.width * 0.6,
                            //   child: Image.asset(
                            //     'assets/images/qrcode_1.png',
                            //     fit: BoxFit.contain,
                            //   ),
                            // ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                ),
                                PrettyQr(
                                  size: MediaQuery.of(context).size.width * 0.5,
                                  data: safeQrDataPending,
                                  errorCorrectLevel: QrErrorCorrectLevel.M,
                                  roundEdges: true,
                                  typeNumber: 5,
                                  elementColor: Colors.black,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: 'Available on: ',
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
                              height: MediaQuery.of(context).size.height * 0.01,
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
                                                0.02),
                                      ),
                                      TextSpan(
                                        text: '-',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
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
                                                0.02),
                                      ),
                                      TextSpan(
                                        text: '-',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        children: [
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
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
