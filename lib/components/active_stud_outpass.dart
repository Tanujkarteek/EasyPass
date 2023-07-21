// ignore_for_file: prefer_const_constructors

import 'package:easypass/components/timer.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'frostedglass.dart';

class ActiveStudPass extends StatefulWidget {
  //final ValueChanged<StreamBuilder>? onBuildCallActiveData;
  final List<Map<String, dynamic>> activeData;
  final bool isReset;
  final int index;

  const ActiveStudPass({
    super.key,
    required this.activeData,
    required this.index,
    required this.isReset,
  });

  @override
  State<ActiveStudPass> createState() => _ActiveStudPassState();
}

class _ActiveStudPassState extends State<ActiveStudPass> {
  List<Map<String, dynamic>> get data => widget.activeData;
  bool get isReset => widget.isReset;
  // late Timer timer;
  // bool isContentVisible = true;
  // bool isNearExpiry = false;

  late String leaveTimeString;
  late String inTimeString;
  late String leaveTimeHour;
  late String leaveTimeMinute;
  late String leaveTimePeriod;
  late String inTimeHour;
  late String inTimeMinute;
  late String inTimePeriod;

  void returnTime() {
    leaveTimeString = data[0]['leaveTime'].toString();
    inTimeString = data[0]['inTime'].toString();
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
  void initState() {
    super.initState();
    returnTime();
    //startTimer();
  }

  @override
  void didUpdateWidget(covariant ActiveStudPass oldWidget) {
    super.didUpdateWidget(oldWidget);
    returnTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    returnTime();
  }

  // void dispose() {
  //   // Cancel the timer when the widget is disposed
  //   timer.cancel();
  //   super.dispose();
  // }

  // void startTimer() {
  //   const duration = Duration(seconds: 15);
  //   timer = Timer.periodic(duration, (timer) {
  //     print("hehe");
  //     checkExpiry();
  //     // In this example, we're incrementing a counter every second
  //   });
  // }

  // void checkExpiry() {
  //   var currentTime = DateTime.now();
  //   String time = DateFormat('h:mm a').format(currentTime);
  //   List<String> currentTimeParts = time.split(RegExp(r'[:\s]'));
  //   var hourNow = int.parse(currentTimeParts[0]);
  //   var minuteNow = int.parse(currentTimeParts[1]);

  //   String inTime = data[0]['inTime'];
  //   List<String> inTimeParts = inTime.split(RegExp(r'[:\s]'));

  //   var hours = int.parse(inTimeParts[0]);
  //   var minutes = int.parse(inTimeParts[1]);

  //   var hourDiff = hours - hourNow;
  //   var minDiff = minutes - minuteNow;
  //   print(minDiff);
  //   print(hourDiff);
  //   if (minutes < 0) {
  //     minutes = minutes + 60;
  //     hours = hours - 1;
  //   }
  //   if (hourDiff == 0 && minDiff < 30 && minDiff >= 0) {
  //     isNearExpiry = true;
  //   } else {
  //     isNearExpiry = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FrostedGlassBox(
      theHeight: MediaQuery.of(context).size.height * 0.546,
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
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Outpass #',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: "1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: data[0]['place'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
              ),
              PrettyQr(
                size: MediaQuery.of(context).size.width * 0.5,
                //make data qrdata or something else so that is null safe
                data: data[0]['outpassId'] ?? "No Data",
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
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              RichText(
                text: const TextSpan(
                  children: <TextSpan>[
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
          CountdownTimer(
            inTime: data[0]['inTime'],
            outpassId: data[0]['outpassId'],
            userId: data[0]['user_id'],
            isReset: isReset,
            //expiryTime: data[0]['expiry'],
          ),
          // Row(
          //   // ignore: prefer_const_literals_to_create_immutables
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     RichText(
          //       text: TextSpan(
          //         children: [
          //           const TextSpan(
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
          //                 width: MediaQuery.of(context).size.width * 0.005),
          //           ),
          //           const TextSpan(
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
          //                 width: MediaQuery.of(context).size.width * 0.02),
          //           ),
          //           const TextSpan(
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
          //                 width: MediaQuery.of(context).size.width * 0.005),
          //           ),
          //           const TextSpan(
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
          //                 width: MediaQuery.of(context).size.width * 0.02),
          //           ),
          //           const TextSpan(
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
          //                 width: MediaQuery.of(context).size.width * 0.005),
          //           ),
          //           const TextSpan(
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
                    text: const TextSpan(
                      children: <TextSpan>[
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
                              width: MediaQuery.of(context).size.width * 0.01),
                        ),
                        const TextSpan(
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
                                    MediaQuery.of(context).size.width * 0.01)),
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
                                    MediaQuery.of(context).size.width * 0.005)),
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
                    text: const TextSpan(
                      children: <TextSpan>[
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
                              width: MediaQuery.of(context).size.width * 0.01),
                        ),
                        const TextSpan(
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
                                    MediaQuery.of(context).size.width * 0.01)),
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
                                    MediaQuery.of(context).size.width * 0.005)),
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
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
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
                          text: data[0]['handler'],
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
    );
  }
}
