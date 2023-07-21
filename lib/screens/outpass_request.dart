// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/loading.dart';
import 'package:easypass/components/notification/notif.dart';
import 'package:easypass/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/frostedglass.dart';
import '../components/timepicker.dart';

//import 'package:intl/intl.dart';

class RequestPage extends StatefulWidget {
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  OverlayEntry? overlayEntry;
  String? overlayValue1, overlayValue2;
  bool isLoading = false;

  Widget openOverlay1Widget() {
    return GestureDetector(
      child: NumberOverlay(
        onCloseOverlay: closeOverlay1,
      ),
    );
  }

  Widget openOverlay2Widget() {
    return GestureDetector(
      child: NumberOverlay(
        onCloseOverlay: closeOverlay2,
      ),
    );
  }

  // void openOverlay1() {
  //   overlayEntry = OverlayEntry(builder: (context) {
  //     return GestureDetector(
  //       child: NumberOverlay(
  //         onCloseOverlay: closeOverlay1,
  //       ),
  //     );
  //   });

  //   Overlay.of(context)?.insert(overlayEntry!);
  // }

  // void openOverlay2() {
  //   overlayEntry = OverlayEntry(
  //     builder: (context) => NumberOverlay(onCloseOverlay: closeOverlay2),
  //   );

  //   Overlay.of(context)?.insert(overlayEntry!);
  // }

  void closeOverlay1(String value) {
    setState(() {
      overlayValue1 = value;
    });
    setState(() {
      _leavetime.text = overlayValue1.toString();
      overlayValue1 = null;
    });

    overlayEntry?.remove();
    overlayEntry = null;
  }

  void closeOverlay2(String value) {
    setState(() {
      overlayValue2 = value;
    });
    setState(() {
      _intime.text = overlayValue2.toString();
      overlayValue2 = null;
    });

    overlayEntry?.remove();
    overlayEntry = null;
  }

  final TextEditingController _date = TextEditingController();
  final TextEditingController _leavetime = TextEditingController();
  final TextEditingController _intime = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _warden = TextEditingController();
  final TextEditingController _purpose = TextEditingController();
  var pickedoutTime;
  var pickedinTime;
  final userdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    //String selectedOption = "Place";

    List<String> places = [
      'Place',
      'Pala,In',
      'Kottayam,In',
      'Kochi,In',
    ];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LoadingOverlayWidget(
        isLoading: isLoading,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
            child: FloatingActionButton(
              elevation: 50.0,
              onPressed: () {
                Navigator.pop(context);
                selectionClick();
              },
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
                  children: <TextSpan>[
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
                      text: userdata.read('name').toString().split(' ')[0],
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                  // NotifHitter().hitUrl();
                  selectionClick();
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.06,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      FrostedGlassBox(
                        theWidth: MediaQuery.of(context).size.width * 0.9,
                        theHeight: MediaQuery.of(context).size.height * 0.78,
                        theChild: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
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
                                              color: Color.fromRGBO(
                                                  14, 183, 145, 1),
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
                                                      _place.text =
                                                          places[index];
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
                                    hintText: "Place",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
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
                                    hintText: "Date",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: TextField(
                                  controller: _leavetime,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            insetPadding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            content: openOverlay1Widget(),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  //call the getTime() function from timepicker.dart

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
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
                                    hintText: "Leave Time",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: TextField(
                                  controller: _intime,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            insetPadding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            content: openOverlay2Widget(),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  //call the getTime() function from timepicker.dart

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
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
                                    hintText: "In Time",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height * 0.08,
                              //   width: MediaQuery.of(context).size.width * 0.75,
                              //   child: TextField(
                              //     focusNode: AlwaysDisabledFocusNode(),
                              //     readOnly: true,
                              //     //create a dropdown inside the textfield
                              //     controller: _warden,
                              //     onTap: () => {
                              //       showDialog(
                              //         context: context,
                              //         builder: (BuildContext context) {
                              //           return AlertDialog(
                              //             elevation: 100,
                              //             shape: RoundedRectangleBorder(
                              //               borderRadius:
                              //                   BorderRadius.circular(20.0),
                              //             ),
                              //             backgroundColor:
                              //                 Color.fromRGBO(66, 66, 66, 1),
                              //             title: Text(
                              //               "Select a warden",
                              //               style: TextStyle(
                              //                 color:
                              //                     Color.fromRGBO(14, 183, 145, 1),
                              //                 fontFamily: "Montserrat",
                              //                 fontWeight: FontWeight.w700,
                              //               ),
                              //             ),
                              //             content: Container(
                              //               width: MediaQuery.of(context)
                              //                       .size
                              //                       .width *
                              //                   0.9,
                              //               height: MediaQuery.of(context)
                              //                       .size
                              //                       .height *
                              //                   0.5,
                              //               child: ListView.builder(
                              //                 itemCount: wardens.length,
                              //                 itemBuilder: (context, index) {
                              //                   return ListTile(
                              //                     title: Text(wardens[index]),
                              //                     onTap: () {
                              //                       setState(() {
                              //                         _warden.text =
                              //                             wardens[index];
                              //                       });
                              //                       Navigator.pop(context);
                              //                     },
                              //                   );
                              //                 },
                              //               ),
                              //             ),
                              //           );
                              //         },
                              //       ),
                              //     },
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontFamily: "Montserrat",
                              //         fontSize: 20,
                              //         fontWeight: FontWeight.w500),
                              //     textAlign: TextAlign.center,
                              //     decoration: InputDecoration(
                              //       fillColor: Color.fromRGBO(14, 183, 145, 0.6),
                              //       filled: true,
                              //       focusColor: Color.fromRGBO(0, 53, 88, 0.294),
                              //       border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(18),
                              //       ),
                              //       hintStyle: TextStyle(
                              //           color: Colors.white,
                              //           fontFamily: "Montserrat"),
                              //       hintText: "Designated Warden",
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4, top: 14),
                                child: Column(
                                  //crossAxisAlignment:CrossAxisAlignment.end,
                                  children: <Widget>[
                                    ElevatedButton(
                                      //onPressed: signIN,
                                      onPressed: () {
                                        // if (_formKey.currentState!.validate()) {
                                        //   signIN();
                                        // }
                                        setState(() {
                                          isLoading = true;
                                        });
                                        selectionClick();
                                        if (_intime.text.isNotEmpty &&
                                            _leavetime.text.isNotEmpty &&
                                            _place.text != "Place" &&
                                            _place.text.isNotEmpty &&
                                            _date.text != "Date" &&
                                            _date.text.isNotEmpty &&
                                            _purpose.text.isNotEmpty) {
                                          if (validTime()) {
                                            pushData();
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            purgeTime();
                                            AnimatedSnackBar.material(
                                              "Please enter valid time",
                                              type: AnimatedSnackBarType.error,
                                              mobileSnackBarPosition:
                                                  MobileSnackBarPosition.bottom,
                                            ).show(context);
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          AnimatedSnackBar.material(
                                            "Please enter valid field values",
                                            type: AnimatedSnackBarType.error,
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.bottom,
                                          ).show(context);
                                          //purge all the text fields
                                          purgeFields();
                                        }
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
                                          color:
                                              Color.fromRGBO(14, 183, 145, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  purgeFields();
                                  selectionClick();
                                },
                                child: Text(
                                  "Reset",
                                  style: TextStyle(
                                    fontFamily: 'Cascadia',
                                    fontSize: 20,
                                  ),
                                ),
                              )
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
      ),
    );
  }

  bool validTime() {
    var currentTime = DateTime.now();
    // change current time to 12 hour format
    String time = DateFormat.jm().format(currentTime);

    return parseTimeString(_intime.text)
                .isAfter(parseTimeString(_leavetime.text)) ==
            true && /*check if intime is before 21:00*/ parseTimeString(
                    _intime.text)
                .isBefore(parseTimeString("09:00 PM")) ==
            true /*check if leavetime is after 09:00 AM*/ &&
        parseTimeString(_leavetime.text).isAfter(parseTimeString("06:00 AM")) ==
            true &&
        checkNow() == true;

    //  parseTimeString(
    //                 _leavetime.text)
    //             .isAfter(parseTimeString(time)) ==
    //         true;
    // leaveHour > nowHour == true;
    //     true /*check if intime is after the now time*/ &&
    // parseTimeString(_leavetime.text).isAfter(parseTimeString(time)) == true;
  }

  bool checkNow() {
    var currentTime = DateTime.now();
    String time = DateFormat('dd-MM-yyyy').format(currentTime);
    String nowtime = DateFormat('hh:mm a').format(currentTime);
    String date = _date.text;
    //print(parseTimeString(_leavetime.text).isAfter(parseTimeString(nowtime)));
    if (time == date) {
      return parseTimeString(_leavetime.text)
              .isAfter(parseTimeString(nowtime)) ==
          true;
    } else {
      //print("i am called");
      return true;
    }
  }

  Future<void> pushData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_name = prefs.getString('name');
    String? user_rollno = prefs.getString('rollno');
    String? user_hostel = prefs.getString('hostel');
    User? user = FirebaseAuth.instance.currentUser;

    String expiry = calculateExpiry(_intime.text, _leavetime.text);

    FirebaseFirestore.instance.collection('logs').doc(user!.uid);
    var userData = FirebaseFirestore.instance.collection('users').doc(user.uid);
    Map<String, dynamic> tempData1 = {};
    await userData.get().then((value) {
      tempData1 = value.data()!;
    });

    CollectionReference logs = FirebaseFirestore.instance.collection('logs');
    Map<String, dynamic> data = {
      'user_id': user.uid,
      'name': user_name,
      'rollno': user_rollno,
      'hostel': user_hostel,
      'date': _date.text,
      'inTime': _intime.text,
      'leaveTime': _leavetime.text,
      'place': _place.text,
      'purpose': _purpose.text,
      'expiry': expiry,
      'time_created': DateTime.now(),
      'status': 'pending',
      'isScanned': 'no',
      'denyReason': '',
      'outpassId': '',
      'handler': '',
      'extended': '',
      'extendReason': '',
      'extendPeriod': '',
      'extendHandler': '',
      'used': 'no',
    };

    DocumentReference newDocumentRef = await logs.add(data);
    String autoGeneratedDocId = newDocumentRef.id;
    await logs.doc(autoGeneratedDocId).update({
      'outpassId': autoGeneratedDocId,
    });

    isLoading = false;

    purgeFields();
    // ignore: use_build_context_synchronously
    AnimatedSnackBar.material(
      "Request submitted successfully",
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    ).show(context);
    // ignore: use_build_context_synchronously
    Navigator.popAndPushNamed(context, '/stud_dash');
    NotifHitter().hitUrl();
  }

  String calculateExpiry(String intime, String leavetime) {
    DateTime intimeDateTime = parseTimeString(intime);
    DateTime leavetimeDateTime = parseTimeString(leavetime);

    intimeDateTime = intimeDateTime.subtract(Duration(minutes: 1));

    int hourDifference = intimeDateTime.hour - leavetimeDateTime.hour;
    int minuteDifference = intimeDateTime.minute - leavetimeDateTime.minute;

    if (minuteDifference < 0) {
      minuteDifference += 60;
      hourDifference -= 1;
    }
    String expiry =
        '${hourDifference.toString().padLeft(2, '0')}:${minuteDifference.toString().padLeft(2, '0')}';

    return expiry;
  }

  DateTime parseTimeString(String timeString) {
    int hour = int.parse(timeString.substring(0, 2));
    int minute = int.parse(timeString.substring(3, 5));
    String period = timeString.substring(6).trim().toUpperCase();

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(0, 1, 1, hour, minute);
  }

  void purgeFields() {
    //purge all the text fields
    _purpose.clear();
    _place.clear();
    _date.clear();
    _leavetime.clear();
    _intime.clear();
    _warden.clear();
  }

  void purgeTime() {
    //purge all the text fields
    _leavetime.clear();
    _intime.clear();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}




// TimeOfDay? pickedInTime =
                                  //     await showTimePicker(
                                  //   context: context,
                                  //   initialTime: TimeOfDay.now(),
                                  //   builder:
                                  //       (BuildContext context, Widget? child) {
                                  //     return MediaQuery(
                                  //       data: MediaQuery.of(context).copyWith(
                                  //           alwaysUse24HourFormat: false),
                                  //       child: child!,
                                  //     );
                                  //   },
                                  // );

                                  // if (pickedInTime != null) {
                                  //   setState(() {
                                  //     pickedoutTime = pickedInTime;
                                  //     _leavetime.text = TimeOfDay(
                                  //       hour: pickedInTime.hour,
                                  //       minute: pickedInTime.minute,
                                  //     ).format(context);
                                  //     // final period =
                                  //     //     pickedInTime.period == DayPeriod.am
                                  //     //         ? 'AM'
                                  //     //         : 'PM';
                                  //     // final time = _leavetime.text;
                                  //     // _leavetime.text = '$time $period';
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     _leavetime.text = "Leave Time";
                                  //   });
                                  // }
                                  //openOverlay1();

                                  // TimeOfDay? pickedInTime =
                                  //     await showTimePicker(
                                  //   context: context,
                                  //   initialTime: TimeOfDay.now(),
                                  //   builder:
                                  //       (BuildContext context, Widget? child) {
                                  //     return MediaQuery(
                                  //       data: MediaQuery.of(context).copyWith(
                                  //           alwaysUse24HourFormat: false),
                                  //       child: child!,
                                  //     );
                                  //   },
                                  // );

                                  // if (pickedInTime != null) {
                                  //   pickedinTime = pickedInTime;
                                  //   setState(() {
                                  //     _intime.text = TimeOfDay(
                                  //       hour: pickedInTime.hour,
                                  //       minute: pickedInTime.minute,
                                  //     ).format(context);
                                  //     // _intime.text = TimeOfDay(
                                  //     //   hour: pickedInTime.hour % 12,
                                  //     //   minute: pickedInTime.minute,
                                  //     // ).format(context);
                                  //     // final period =
                                  //     //     pickedInTime.period == DayPeriod.pm
                                  //     //         ? 'AM'
                                  //     //         : 'PM';
                                  //     // final time = _intime.text;
                                  //     // _intime.text = '$time $period';

                                  //     // if (pickedInTime.period == DayPeriod.pm) {
                                  //     //   //change last 2 charecter in string to PM
                                  //     //   _intime.text = "${_intime.text} PM";
                                  //     // } else {
                                  //     //   _intime.text = "${_intime.text} PM";
                                  //     // }
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     _intime.text = "In Time";
                                  //   });
                                  // }
                                  // import number page from components folder and open a overlay of it
                                  //open overlay in dialog box
                                  //openOverlay2();