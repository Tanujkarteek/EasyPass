// ignore_for_file: prefer_const_constructors

import 'package:easypass/components/frostedglass.dart';
import 'package:easypass/components/timer_active.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActiveOutpass extends StatefulWidget {
  final int index;
  final List<Map<String, dynamic>> data;
  const ActiveOutpass({super.key, required this.index, required this.data});

  @override
  State<ActiveOutpass> createState() => _ActiveOutpassState();
}

class _ActiveOutpassState extends State<ActiveOutpass> {
  int get index => widget.index;
  List<Map<String, dynamic>> get data => widget.data;
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  bool isContentVisible = true;

  void toggleContentVisibility() {
    setState(() {
      isContentVisible = !isContentVisible;
    });
  }

  late String leaveTimeString;
  late String inTimeString;
  late String leaveTimeHour;
  late String leaveTimeMinute;
  late String leaveTimePeriod;
  late String inTimeHour;
  late String inTimeMinute;
  late String inTimePeriod;

  @override
  void initState() {
    super.initState();
    returnTime();
    //returnDate();
    //returnOutpassID();
  }

  @override
  void didUpdateWidget(covariant ActiveOutpass oldWidget) {
    super.didUpdateWidget(oldWidget);
    returnTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    returnTime();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        toggleContentVisibility();
        selectionClick();
      },
      child: isContentVisible
          ? FrostedGlassBox(
              theHeight: MediaQuery.of(context).size.height * 0.32,
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
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Outpass #',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: (index + 1).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
                          children: <TextSpan>[
                            TextSpan(
                              text: data[index]['place'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Cascadia',
                                fontWeight: FontWeight.w400,
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
                        text: data[index]['name'],
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
                    height: MediaQuery.of(context).size.height * 0.01,
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
                    height: MediaQuery.of(context).size.height * 0.001,
                  ),
                  ActiveCountdownTimer(
                    outpassId: data[index]['outpassId'],
                    inTime: data[index]['inTime'],
                  ),
                  // Row(
                  //   // ignore: prefer_const_literals_to_create_immutables
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     RichText(
                  //       text: TextSpan(
                  //         children: [
                  //           TextSpan(
                  //             text: 'XX',
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
                  //             text: 'h',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //           ),
                  //           WidgetSpan(
                  //             child: SizedBox(
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.02),
                  //           ),
                  //           TextSpan(
                  //             text: 'XX',
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
                  //             text: 'm',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //           ),
                  //           WidgetSpan(
                  //             child: SizedBox(
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.02),
                  //           ),
                  //           TextSpan(
                  //             text: 'XX',
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
                  //             text: 's',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontFamily: 'Montserrat',
                  //               fontWeight: FontWeight.w400,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
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
                                    fontSize: 16,
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
                                    fontSize: 16,
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
                                    fontSize: 16,
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
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
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
                                  text: inTimeHour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                                    fontSize: 16,
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
                                    fontSize: 16,
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
                                  text: data[index]['handler'],
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
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : FrostedGlassBox(
              theHeight: MediaQuery.of(context).size.height * 0.32,
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
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Outpass #',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: (index + 1).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
                          children: <TextSpan>[
                            TextSpan(
                              text: data[index]['place'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Cascadia',
                                fontWeight: FontWeight.w400,
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
                        text: data[index]['name'],
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
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(183, 104, 14, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        print("Notify for Return");
                        selectionClick();
                      },
                      child: Text(
                        "Notify for Return",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Cascadia',
                          fontWeight: FontWeight.w700,
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
