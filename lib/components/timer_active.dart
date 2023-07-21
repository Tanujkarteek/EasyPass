import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActiveCountdownTimer extends StatefulWidget {
  final String outpassId;
  // final String userId;
  final String inTime;
  //final String expiry;
  const ActiveCountdownTimer({
    super.key,
    required this.outpassId,
    required this.inTime,
    // required this.inTime,
    // required this.userId,
  });

  @override
  State<ActiveCountdownTimer> createState() => _ActiveCountdownTimerState();
}

class _ActiveCountdownTimerState extends State<ActiveCountdownTimer> {
  String get inTime => widget.inTime;
  // String get userId => widget.userId;
  String get outpassId => widget.outpassId;
  //String get expiry => widget.expiry;
  bool isNotExpired = true;
  late Duration duration;
  Timer? timer;
  bool isCountdown = true;
  @override
  void initState() {
    super.initState();
    returnExpiryTime();
    setTimer();
    startTimer();
    //reset();
  }

  late String newExpiryTime;

  late int hours;
  late int minutes;

  void returnExpiryTime() {
    // expiryTime is in format 09:59
    List<String> inTimeParts = inTime.split(RegExp(r'[:\s]'));

    hours = int.parse(inTimeParts[0]);
    minutes = int.parse(inTimeParts[1]);
    var currentTime = DateTime.now();
    String time = DateFormat('h:mm a').format(currentTime);
    List<String> currentTimeParts = time.split(RegExp(r'[:\s]'));
    var hourNow = int.parse(currentTimeParts[0]);
    var minuteNow = int.parse(currentTimeParts[1]);
    // print(hourNow);
    // print(minuteNow);

    // convert the expiryTime into int
    hours = int.parse(inTimeParts[0]);
    minutes = int.parse(inTimeParts[1]);

    // update the hours and minutes
    hours = hours - hourNow;
    minutes = minutes - minuteNow - 1;

    // if the minutes are negative, add 60 to it and subtract 1 from hours
    if (minutes < 0) {
      minutes = minutes + 60;
      hours = hours - 1;
    }
    // if the hours are negative, add 24 to it
    if (hours < 0) {
      hours = hours + 12;
    }
  }

  void setTimer() {
    if (mounted) {
      if (isCountdown) {
        setState(() {
          duration = Duration(hours: hours, minutes: (minutes), seconds: 0);
        });
      } else {
        setState(() {
          duration = const Duration(hours: 0, minutes: 0, seconds: 0);
        });
      }
    }
  }

  void addTime() {
    if (mounted) {
      setState(() {
        final addSeconds = isCountdown ? -1 : 1;
        final newSeconds = duration.inSeconds + addSeconds;
        if (newSeconds < 0) {
          timer?.cancel();
          setState(() {
            isNotExpired = false;
          });
        } else {
          duration = Duration(seconds: newSeconds);
        }
      });
    }
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Center(
      child: isNotExpired
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: hours,
                        style: const TextStyle(
                          fontSize: 44,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      const TextSpan(
                        text: 'h ',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: minutes,
                        style: const TextStyle(
                          fontSize: 44,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text: 'm ',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: seconds,
                        style: const TextStyle(
                          fontSize: 44,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text: 's',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Text(
              "Expired",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cascadia',
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}
