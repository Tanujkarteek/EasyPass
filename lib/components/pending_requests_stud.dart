// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:flutter/material.dart';
import 'frostedglass.dart';

// ignore: must_be_immutable
class PendingRequestCard extends StatefulWidget {
  Map<String, dynamic> data;
  final int index;
  PendingRequestCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<PendingRequestCard> createState() => _PendingRequestCardState();
}

class _PendingRequestCardState extends State<PendingRequestCard> {
  int get index => widget.index;
  Map<String, dynamic> get data => widget.data;

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
  late Color color;
  String status = 'Pending';

  void returnTime() {
    leaveTimeString = data['leaveTime'].toString();
    inTimeString = data['inTime'].toString();
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
    String date = data['date'].toString();
    List<String> dateParts = date.split(RegExp(r'[-]'));
    day = dateParts[0];
    month = dateParts[1];
    year = dateParts[2];
  }

  @override
  void initState() {
    super.initState();
    //pendingDataFunction();
    returnTime();
    returnDate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FrostedGlassBox(
          theHeight: MediaQuery.of(context).size.height * 0.41,
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
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: data['place'],
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: data['name'],
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: data['purpose'],
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
                          text: 'Status:',
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
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: status,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.01),
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
                                    width: MediaQuery.of(context).size.width *
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
                                    width: MediaQuery.of(context).size.width *
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.01),
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
                                    width: MediaQuery.of(context).size.width *
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
                                    width: MediaQuery.of(context).size.width *
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$day-$month-$year',
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
        ),
      ],
    );
  }
}
