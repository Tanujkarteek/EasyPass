// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/screens/stud_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/frostedglass.dart';
//import 'package:intl/intl.dart';

class RequestPage extends StatefulWidget {
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _leavetime = TextEditingController();
  final TextEditingController _intime = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _warden = TextEditingController();
  final TextEditingController _purpose = TextEditingController();
  var pickedoutTime;
  var pickedinTime;

  @override
  Widget build(BuildContext context) {
    //String selectedOption = "Place";

    List<String> places = [
      'Place',
      'Pala, In',
      'Kottayam, In',
      'Kochi, In',
    ];

    List<String> wardens = [
      'Designated Warden',
      'Dr. Bhanu',
      'Dr. Santosh',
      'Dr. Keshabh Nath',
    ];
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
          child: FloatingActionButton(
            elevation: 50.0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudDash(),
              ),
            ),
            backgroundColor: Color.fromRGBO(14, 183, 145, 1),
            child: Icon(
              Icons.close,
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
                Navigator.popAndPushNamed(context, '/welcome'),
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
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Color.fromRGBO(0, 146, 121, 1),
                //     Color.fromRGBO(173, 224, 129, 1)
                //   ],
                // ),
                color: Color.fromRGBO(30, 30, 30, 1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  //width: MediaQuery.of(context).size.width,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.03,
                    // ),
                    // Container(
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
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    FrostedGlassBox(
                      theWidth: MediaQuery.of(context).size.width * 0.9,
                      theHeight: MediaQuery.of(context).size.height * 0.82,
                      theChild: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.002,
                            ),
                            SizedBox(
                              //height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Center(
                                child: TextFormField(
                                  controller: _purpose,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                  maxLength: 300,
                                  minLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    fillColor:
                                        Color.fromRGBO(14, 183, 145, 0.6),
                                    filled: true,
                                    focusColor:
                                        Color.fromRGBO(0, 53, 88, 0.294),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                    hintText: "Purpose",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TextField(
                                focusNode: AlwaysDisabledFocusNode(),
                                readOnly: true,
                                //create a dropdown inside the textfield
                                controller: _place,
                                onTap: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        elevation: 100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor:
                                            Color.fromRGBO(66, 66, 66, 1),
                                        title: Text(
                                          "Select a place",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(14, 183, 145, 1),
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: ListView.builder(
                                            itemCount: places.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(places[index]),
                                                onTap: () {
                                                  setState(() {
                                                    _place.text = places[index];
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(14, 183, 145, 0.6),
                                  filled: true,
                                  focusColor: Color.fromRGBO(0, 53, 88, 0.294),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat"),
                                  hintText: "Place",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TextField(
                                controller: _date,
                                focusNode: AlwaysDisabledFocusNode(),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2035),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _date.text = DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                    });
                                  } else {
                                    setState(() {
                                      _date.text = "Date";
                                    });
                                  }
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(14, 183, 145, 0.6),
                                  filled: true,
                                  focusColor: Color.fromRGBO(0, 53, 88, 0.294),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat"),
                                  hintText: "Date",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TextField(
                                controller: _leavetime,
                                focusNode: AlwaysDisabledFocusNode(),
                                onTap: () async {
                                  TimeOfDay? pickedInTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedInTime != null) {
                                    setState(() {
                                      pickedoutTime = pickedInTime;
                                      _leavetime.text = TimeOfDay(
                                        hour: pickedInTime.hour,
                                        minute: pickedInTime.minute,
                                      ).format(context);
                                      // final period =
                                      //     pickedInTime.period == DayPeriod.am
                                      //         ? 'AM'
                                      //         : 'PM';
                                      // final time = _leavetime.text;
                                      // _leavetime.text = '$time $period';
                                    });
                                  } else {
                                    setState(() {
                                      _leavetime.text = "Leave Time";
                                    });
                                  }
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(14, 183, 145, 0.6),
                                  filled: true,
                                  focusColor: Color.fromRGBO(0, 53, 88, 0.294),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat"),
                                  hintText: "Leave Time",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TextField(
                                controller: _intime,
                                focusNode: AlwaysDisabledFocusNode(),
                                onTap: () async {
                                  TimeOfDay? pickedInTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedInTime != null) {
                                    pickedinTime = pickedInTime;
                                    setState(() {
                                      _intime.text = TimeOfDay(
                                        hour: pickedInTime.hour,
                                        minute: pickedInTime.minute,
                                      ).format(context);
                                      // _intime.text = TimeOfDay(
                                      //   hour: pickedInTime.hour % 12,
                                      //   minute: pickedInTime.minute,
                                      // ).format(context);
                                      // final period =
                                      //     pickedInTime.period == DayPeriod.pm
                                      //         ? 'AM'
                                      //         : 'PM';
                                      // final time = _intime.text;
                                      // _intime.text = '$time $period';

                                      // if (pickedInTime.period == DayPeriod.pm) {
                                      //   //change last 2 charecter in string to PM
                                      //   _intime.text = "${_intime.text} PM";
                                      // } else {
                                      //   _intime.text = "${_intime.text} PM";
                                      // }
                                    });
                                  } else {
                                    setState(() {
                                      _intime.text = "In Time";
                                    });
                                  }
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(14, 183, 145, 0.6),
                                  filled: true,
                                  focusColor: Color.fromRGBO(0, 53, 88, 0.294),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat"),
                                  hintText: "In Time",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TextField(
                                focusNode: AlwaysDisabledFocusNode(),
                                readOnly: true,
                                //create a dropdown inside the textfield
                                controller: _warden,
                                onTap: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        elevation: 100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor:
                                            Color.fromRGBO(66, 66, 66, 1),
                                        title: Text(
                                          "Select a warden",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(14, 183, 145, 1),
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: ListView.builder(
                                            itemCount: wardens.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(wardens[index]),
                                                onTap: () {
                                                  setState(() {
                                                    _warden.text =
                                                        wardens[index];
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                },
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(14, 183, 145, 0.6),
                                  filled: true,
                                  focusColor: Color.fromRGBO(0, 53, 88, 0.294),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat"),
                                  hintText: "Designated Warden",
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 1, top: 14),
                              child: Column(
                                //crossAxisAlignment:CrossAxisAlignment.end,
                                children: <Widget>[
                                  ElevatedButton(
                                    //onPressed: signIN,
                                    onPressed: () {
                                      // if (_formKey.currentState!.validate()) {
                                      //   signIN();
                                      // }
                                      pushData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.only(
                                          left: 45,
                                          right: 45,
                                          top: 10,
                                          bottom: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14.0)),
                                    ),
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(14, 183, 145, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.002,
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
        ),
      ),
    );
  }

  Future<void> pushData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_name = prefs.getString('name');
    String? user_rollno = prefs.getString('rollno');
    String? user_hostel = prefs.getString('hostel');
    User? user = FirebaseAuth.instance.currentUser;
    TimeOfDay expiry = TimeOfDay(
      hour: pickedinTime.hour - pickedoutTime.hour,
      minute: pickedinTime.minute - pickedoutTime.minute,
    );
    if (expiry.minute < 0) {
      expiry = TimeOfDay(
        hour: expiry.hour - 1,
        minute: expiry.minute + 60,
      );
    }
    if (expiry.minute == 0) {
      expiry = TimeOfDay(
        hour: expiry.hour,
        minute: 00,
      );
    }
    //last changes
    //DocumentReference userDocRef =
    FirebaseFirestore.instance.collection('logs').doc(user!.uid);
    // CollectionReference collectionRef = userDocRef.collection(user.uid);
    //create a collection reference to a collection called logs
    CollectionReference logs = FirebaseFirestore.instance.collection('logs');
    Map<String, dynamic> data = {
      'user_id': user.uid,
      'hostel': user_hostel,
      'time_created': DateTime.now(),
      'expiry': '${expiry.hour}:${expiry.minute}',
      'guard': '',
      'inTime': _intime.text,
      'leaveTime': _leavetime.text,
      'name': user_name,
      'rollno': user_rollno,
      'outpassId': '',
      'place': _place.text,
      'purpose': _purpose.text,
      'status': 'pending',
      'isScanned': 'no',
      //'warden': _warden.text,
      'date': _date.text,
    };
    // ignore: unused_local_variable
    //DocumentReference newDocumentRef = await collectionRef.add(data);
    DocumentReference newDocumentRef = await logs.add(data);
    String autoGeneratedDocId = newDocumentRef.id;
    await logs.doc(autoGeneratedDocId).update({
      'outpassId': autoGeneratedDocId,
    });
    //clearing the text fields
    _purpose.clear();
    _place.clear();
    _date.clear();
    _leavetime.clear();
    _intime.clear();
    _warden.clear();
    // ignore: unused_local_variable
    final snackBar = SnackBar(
      content: Text(
        'Request Submitted',
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color.fromRGBO(14, 183, 145, 1),
        ),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
