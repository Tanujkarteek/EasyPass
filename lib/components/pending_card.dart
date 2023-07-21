// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/frostedglass.dart';
import 'package:easypass/components/timepicker.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/past_activities.dart';

// ignore: must_be_immutable
class PendingOutpass extends StatefulWidget {
  final int index;
  final String outpassId;
  final List<Map<String, dynamic>> data;
  Future<void> Function(String) approveRequest;
  Future<void> Function(String, String) denyRequest;
  PendingOutpass({
    super.key,
    required this.index,
    required this.data,
    //required this.callPendingOutpass,
    required this.outpassId,
    required this.approveRequest,
    required this.denyRequest,
  });

  @override
  State<PendingOutpass> createState() => _PendingOutpassState();
}

class _PendingOutpassState extends State<PendingOutpass> {
  // get index from parent class
  String get outpassID => widget.outpassId;
  int get index => widget.index;
  Function get approveRequest => widget.approveRequest;
  Function get denyRequest => widget.denyRequest;
  List<Map<String, dynamic>> get data => widget.data;
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  TextEditingController denyReasonController = TextEditingController();
  TextEditingController leavetime = TextEditingController();
  TextEditingController intime = TextEditingController();

  late String leaveTimeString;
  late String inTimeString;
  late String leaveTimeHour;
  late String leaveTimeMinute;
  late String leaveTimePeriod;
  late String inTimeHour;
  late String inTimeMinute;
  late String inTimePeriod;
  late String day;
  late String month;
  late String year;

  @override
  void initState() {
    super.initState();
    returnTime();
    returnDate();
    setState(() {
      leavetime.text = data[index]['leaveTime'].toString();
      intime.text = data[index]['inTime'].toString();
    });
    //returnOutpassID();
  }

  @override
  void didUpdateWidget(covariant PendingOutpass oldWidget) {
    super.didUpdateWidget(oldWidget);
    returnTime();
    returnDate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //pendingDataFunction();
    returnTime();
    returnDate();
  }
  // void returnOutpassID() {
  //   outpassID = data[index]['outpassId'].toString();
  // }

  void returnDate() {
    String date = data[index]['date'].toString();
    List<String> dateParts = date.split(RegExp(r'[-]'));
    day = dateParts[0];
    month = dateParts[1];
    year = dateParts[2];
  }

  void returnTime() {
    leaveTimeString = data[index]['leaveTime'].toString();
    inTimeString = data[index]['inTime'].toString();
    List<String> leaveTimeParts = leaveTimeString.split(RegExp(r'[:\s]'));
    List<String> inTimeParts = inTimeString.split(RegExp(r'[:\s]'));
    leaveTimeHour = leaveTimeParts[0];
    leaveTimeMinute = leaveTimeParts[1];
    leaveTimePeriod = leaveTimeParts[2];
    inTimeHour = inTimeParts[0];
    inTimeMinute = inTimeParts[1];
    inTimePeriod = inTimeParts[2];
  }

  OverlayEntry? overlayEntry;
  String? overlayValue1, overlayValue2;

  Widget openOverlay1Widget() {
    return GestureDetector(
      child: NumberOverlay(
        onCloseOverlay: closeOverlay1,
      ),
    );
  }

  void closeOverlay1(String value) {
    setState(() {
      overlayValue1 = value;
    });
    setState(() {
      leavetime.text = overlayValue1.toString();
      overlayValue1 = null;
    });

    overlayEntry?.remove();
    overlayEntry = null;
  }

  Widget openOverlay2Widget() {
    return GestureDetector(
      child: NumberOverlay(
        onCloseOverlay: closeOverlay2,
      ),
    );
  }

  void closeOverlay2(String value) {
    setState(() {
      overlayValue2 = value;
    });
    setState(() {
      intime.text = overlayValue2.toString();
      overlayValue2 = null;
    });

    overlayEntry?.remove();
    overlayEntry = null;
  }

  bool isContentVisible = true;

  void toggleContentVisibility() {
    setState(() {
      isContentVisible = !isContentVisible;
    });
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

  void setTimings(String leaveTime, String inTime) async {
    setState(() {
      leaveTimeString = leaveTime;
      inTimeString = inTime;
    });
    String expiry = calculateExpiry(inTime, leaveTime);

    await FirebaseFirestore.instance.collection('logs').doc(outpassID).update(
      {
        'leaveTime': leaveTime,
        'inTime': inTime,
        'expiry': expiry,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        toggleContentVisibility();
        selectionClick();
      },
      child: isContentVisible
          ? FrostedGlassBox(
              theHeight: MediaQuery.of(context).size.height * 0.48,
              theWidth: MediaQuery.of(context).size.width * 0.9,
              theChild: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.008,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
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
                              text: (index + 1).toString(),
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
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Edit the Timings"),
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: TextField(
                                            controller: leavetime,
                                            focusNode:
                                                AlwaysDisabledFocusNode(),
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      content:
                                                          openOverlay1Widget(),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            //call the getTime() function from timepicker.dart

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Close",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
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
                                              fillColor: Color.fromRGBO(
                                                  14, 183, 145, 0.6),
                                              filled: true,
                                              focusColor: Color.fromRGBO(
                                                  0, 53, 88, 0.294),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Montserrat"),
                                              hintText: "Leave Time",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: TextField(
                                            controller: intime,
                                            focusNode:
                                                AlwaysDisabledFocusNode(),
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      content:
                                                          openOverlay2Widget(),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            //call the getTime() function from timepicker.dart

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Close",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
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
                                              fillColor: Color.fromRGBO(
                                                  14, 183, 145, 0.6),
                                              filled: true,
                                              focusColor: Color.fromRGBO(
                                                  0, 53, 88, 0.294),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Montserrat"),
                                              hintText: "In Time",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setTimings(leavetime.text, intime.text);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Edit"),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.edit),
                        iconSize: MediaQuery.of(context).size.width * 0.06,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // ignore: sized_box_for_whitespace
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'To:',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${data[index]['place'].toString().split(',')[0]},',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text:
                                  data[index]['place'].toString().split(',')[1],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
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
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
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
                                  text: leaveTimeHour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                ),
                                TextSpan(
                                  text: ':',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                WidgetSpan(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01)),
                                TextSpan(
                                  text: leaveTimeMinute,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                WidgetSpan(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.005)),
                                TextSpan(
                                  text: leaveTimePeriod,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
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
                                  text: inTimeHour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                ),
                                TextSpan(
                                  text: ':',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                WidgetSpan(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01)),
                                TextSpan(
                                  text: inTimeMinute,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                WidgetSpan(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.005)),
                                TextSpan(
                                  text: inTimePeriod,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'On: ',
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
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: day,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.005),
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
                            TextSpan(
                              text: month,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                              ),
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
                            TextSpan(
                              text: year,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Sun',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Name:',
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
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: data[index]['name'].toString(),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Roll Number:',
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
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: data[index]['rollno'].toString(),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            )
          : FrostedGlassBox(
              theHeight: MediaQuery.of(context).size.height * 0.48,
              theWidth: MediaQuery.of(context).size.width * 0.9,
              theChild: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
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
                              text: (index + 1).toString(),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // ignore: sized_box_for_whitespace
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Purpose:',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Expanded(
                        child: Text(
                          data[index]['purpose'].toString(),
                          maxLines: 2,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.006,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Hostel:',
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
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: data[index]['hostel']
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  data[index]['hostel'].toString().substring(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
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
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(14, 183, 145, 1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PastActivities(
                              userId: data[index]['user_id'].toString(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Past Activities",
                        style: TextStyle(
                          color: Color.fromRGBO(30, 30, 30, 1),
                          fontFamily: 'Cascadia',
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.06,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(14, 183, 145, 1),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            approveRequest(outpassID);
                            //callPendingOutpass();
                            selectionClick();
                            isContentVisible = !isContentVisible;
                          },
                          child: Text(
                            "Approve",
                            style: TextStyle(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              fontFamily: 'Cascadia',
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            //denyRequest(outpassID);
                            //callPendingOutpass();
                            // create a dialog box for asking the reason
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Reason for Denial"),
                                  content: TextFormField(
                                    controller: denyReasonController,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Montserrat",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                    maxLength: 300,
                                    minLines: 1,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      fillColor:
                                          Color.fromRGBO(183, 14, 14, 0.33),
                                      filled: true,
                                      focusColor:
                                          Color.fromRGBO(0, 53, 88, 0.294),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat"),
                                      hintText: "Enter the reason",
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        denyRequest(outpassID,
                                            denyReasonController.text);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Deny",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            selectionClick();
                            isContentVisible = !isContentVisible;
                          },
                          child: Text(
                            "Deny",
                            style: TextStyle(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              fontFamily: 'Cascadia',
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                ],
              ),
            ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
