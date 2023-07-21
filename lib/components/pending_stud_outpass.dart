// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:easypass/components/frostedglass.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PendingStudPass extends StatefulWidget {
  final int index;
  // final String leaveTimeString;
  // final String inTimeString;
  final List<Map<String, dynamic>> pendingData;
  // get a reference to a required function
  //final Future<List<Map<String, dynamic>>> Function() pendingDataFunction;

  const PendingStudPass({
    super.key,
    required this.pendingData,
    required this.index,
    // required this.leaveTimeString,
    // required this.inTimeString,
  });

  @override
  State<PendingStudPass> createState() => _PendingStudPassState();
}

class _PendingStudPassState extends State<PendingStudPass> {
  List<Map<String, dynamic>> get pendingData => widget.pendingData;
  // String get leaveTimeString => widget.leaveTimeString;
  // String get inTimeString => widget.inTimeString;

  @override
  void initState() {
    super.initState();
    //pendingDataFunction();
    returnTime();
    returnDate();
  }

  @override
  void didUpdateWidget(covariant PendingStudPass oldWidget) {
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

  int get index => widget.index;
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

  void returnTime() {
    leaveTimeString = pendingData[index]['leaveTime'].toString();
    inTimeString = pendingData[index]['inTime'].toString();
    List<String> leaveTimeParts = leaveTimeString.split(RegExp(r'[:\s]'));
    List<String> inTimeParts = inTimeString.split(RegExp(r'[:\s]'));
    leaveTimeHour = leaveTimeParts[0];
    leaveTimeMinute = leaveTimeParts[1];
    leaveTimePeriod = leaveTimeParts[2];
    inTimeHour = inTimeParts[0];
    inTimeMinute = inTimeParts[1];
    inTimePeriod = inTimeParts[2];
  }

  void returnDate() {
    String date = pendingData[index]['date'].toString();
    List<String> dateParts = date.split(RegExp(r'[-]'));
    day = dateParts[0];
    month = dateParts[1];
    year = dateParts[2];
  }

  @override
  Widget build(BuildContext context) {
    return FrostedGlassBox(
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
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              RichText(
                text: TextSpan(
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
                      text: (index + 1).toString(),
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
              Spacer(),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: pendingData[widget.index]['place'],
                      //text: pendingData[index]['outpassId'].toString(),
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
                data: pendingData[widget.index]['outpassId'] ?? 'No Data',
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
                          width: MediaQuery.of(context).size.width * 0.02),
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
                          width: MediaQuery.of(context).size.width * 0.02),
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
                    WidgetSpan(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02),
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
                          width: MediaQuery.of(context).size.width * 0.02),
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
                  ],
                ),
              ),
            ],
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
                              width: MediaQuery.of(context).size.width * 0.01),
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
                              width: MediaQuery.of(context).size.width * 0.01),
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
                          text: pendingData[index]['handler'],
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
