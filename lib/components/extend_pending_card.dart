// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easypass/components/frostedglass.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PendingExtendOutpass extends StatefulWidget {
  final int index;
  final String outpassId;
  final List<Map<String, dynamic>> data;
  Future<void> Function(String, int, int) approveExtendRequest;
  Future<void> Function(String) denyExtendRequest;
  PendingExtendOutpass({
    super.key,
    required this.index,
    required this.data,
    //required this.callPendingOutpass,
    required this.outpassId,
    required this.approveExtendRequest,
    required this.denyExtendRequest,
  });

  @override
  State<PendingExtendOutpass> createState() => _PendingExtendOutpassState();
}

class _PendingExtendOutpassState extends State<PendingExtendOutpass> {
  // get index from parent class
  String get outpassID => widget.outpassId;
  int get index => widget.index;
  Future<void> Function(String, int, int) get approveExtendRequest =>
      widget.approveExtendRequest;
  Future<void> Function(String) get denyExtendRequest =>
      widget.denyExtendRequest;
  List<Map<String, dynamic>> get data => widget.data;
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

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
  late int period;

  @override
  void initState() {
    super.initState();
    returnTime();
    returnDate();
    //returnOutpassID();
  }

  @override
  void didUpdateWidget(covariant PendingExtendOutpass oldWidget) {
    super.didUpdateWidget(oldWidget);
    //pendingDataFunction();
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

    // return period as int
    period = int.parse(data[index]['extendPeriod'].toString());
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

  bool isContentVisible = true;

  void toggleContentVisibility() {
    setState(() {
      isContentVisible = !isContentVisible;
    });
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
              theHeight: MediaQuery.of(context).size.height * 0.4,
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
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.05,
                  //     ),
                  //     RichText(
                  //       text: TextSpan(
                  //         children: const <TextSpan>[
                  //           TextSpan(
                  //             text: 'To:',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     RichText(
                  //       textAlign: TextAlign.center,
                  //       text: TextSpan(
                  //         children: [
                  //           TextSpan(
                  //             text:
                  //                 '${data[index]['place'].toString().split(',')[0]},',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w700,
                  //             ),
                  //           ),
                  //           TextSpan(
                  //             text:
                  //                 data[index]['place'].toString().split(',')[1],
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  // ),
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
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.05,
                  //     ),
                  //     RichText(
                  //       text: TextSpan(
                  //         children: const <TextSpan>[
                  //           TextSpan(
                  //             text: 'On: ',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.05,
                  //     ),
                  //     RichText(
                  //       text: TextSpan(
                  //         children: [
                  //           TextSpan(
                  //             text: day,
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w900,
                  //             ),
                  //           ),
                  //           WidgetSpan(
                  //             child: SizedBox(
                  //                 width: MediaQuery.of(context).size.width *
                  //                     0.005),
                  //           ),
                  //           TextSpan(
                  //             text: '-',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //           ),
                  //           TextSpan(
                  //             text: month,
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w900,
                  //             ),
                  //           ),
                  //           TextSpan(
                  //             text: '-',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //           ),
                  //           TextSpan(
                  //             text: year,
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w900,
                  //             ),
                  //           ),
                  //           TextSpan(
                  //             text: ' ',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 30,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //           ),
                  //           TextSpan(
                  //             text: 'Sun',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 20,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Reason:',
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
                          data[index]['extendReason'].toString(),
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
                ],
              ),
            )
          : FrostedGlassBox(
              theHeight: MediaQuery.of(context).size.height * 0.4,
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
                              text: 'Time Required:',
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
                              text: "${data[index]['extendPeriod']} minutes",
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
                            approveExtendRequest(outpassID, index, period);
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
                            denyExtendRequest(outpassID);
                            //callPendingOutpass();
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
