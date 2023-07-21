import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountdownTimer extends StatefulWidget {
  final String outpassId;
  final String userId;
  final String inTime;
  final bool isReset;
  //final String expiryTime;

  const CountdownTimer({
    super.key,
    required this.inTime,
    required this.outpassId,
    required this.userId,
    required this.isReset,
    //required this.expiryTime,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  String get inTime => widget.inTime;
  String get outpassId => widget.outpassId;
  String get userId => widget.userId;
  bool get isReset => widget.isReset;

  late Duration duration;
  Timer? timer;
  bool isCountdown = true;
  bool isFirstTime = true;
  @override
  void initState() {
    super.initState();
    returnExpiryTime();
    setTimer();
    startTimer();
    resetFirst();
    //reset();
  }

  // @override
  // void didUpdateWidget(covariant CountdownTimer oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   returnExpiryTime();
  //   setTimer();
  //   //startTimer();
  // }
  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if any relevant properties have changed
    if (widget.isReset != oldWidget.isReset) {
      // Perform necessary actions or updates
      // For example, reset the countdown timer
      reset();
      isFirstTime = false;
      resetFirst();
    }
  }

  // after delay of 20 seconds set isFirstTime to true
  // bool shouldReload = false;
  Future<void> resetFirst() async {
    await Future.delayed(const Duration(seconds: 15));
    //print('resetFirst');
    setState(() {
      isFirstTime = true;
    });
  }

  //get the backend expiry time
  late String expiryTime;
  void getExpiryTime() async {
    var docId = outpassId;
    var doc =
        await FirebaseFirestore.instance.collection('logs').doc(docId).get();
    expiryTime = doc['expiry'];
    String inTime1 = doc['inTime'];
    //print(inTime1);
    List<String> inTimeParts = inTime1.split(RegExp(r'[:\s]'));
    int hours1 = int.parse(inTimeParts[0]);
    int minutes1 = int.parse(inTimeParts[1]);
    var currentTime1 = DateTime.now();
    String time = DateFormat('h:mm a').format(currentTime1);
    List<String> currentTimeParts = time.split(RegExp(r'[:\s]'));
    var hourNow = int.parse(currentTimeParts[0]);
    var minuteNow = int.parse(currentTimeParts[1]);
    int newhours = hours1 - hourNow;
    int newminutes = minutes1 - minuteNow - 1;
    newExpiryTime = '$newhours:$newminutes';
    if (newminutes != minutes1 && newhours != hours1) {
      updateExpiry();
      setState(() => duration =
          Duration(hours: newhours, minutes: newminutes, seconds: 0));
    }
  }

  late String newExpiryTime;

  late int hours;
  late int minutes;

  late int resethours;
  late int resetminutes;

  void returnExpiryTime() {
    // expiryTime is in format 09:59
    // convert each into int
    // get the hours and minutes of the system and convert them into int
    //debugPrint("I am called");
    var currentTime = DateTime.now();
    String time = DateFormat('h:mm a').format(currentTime);
    List<String> currentTimeParts = time.split(RegExp(r'[:\s]'));
    var hourNow = int.parse(currentTimeParts[0]);
    var minuteNow = int.parse(currentTimeParts[1]);
    // print(hourNow);
    // print(minuteNow);

    // convert the expiryTime into int
    List<String> inTimeParts = inTime.split(RegExp(r'[:\s]'));
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

    // print(hours);
    // print(minutes);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours1 = twoDigits(hours);
    final minutes1 = twoDigits(minutes);
    // add the new time to the newExpiryTime
    newExpiryTime = '$hours1:$minutes1';
    // update the expiryTime in the database
    updateExpiry();
    if (hours <= 0 && minutes <= 0) {
      updateStatus();
    }
  }

  Future<void> updateExpiry() async {
    var docId = outpassId;
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(docId)
        .update({'expiry': newExpiryTime});
  }

  Future<void> updateStatus() async {
    var docId = outpassId;
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(docId)
        .update({'status': 'expired'});
  }

  void setTimer() {
    if (mounted) {
      if (isCountdown) {
        setState(() {
          duration = Duration(hours: hours, minutes: minutes, seconds: 0);
        });
      } else {
        setState(() {
          duration = const Duration(hours: 0, minutes: 0, seconds: 0);
        });
      }
    }
  }

  void reset() async {
    if (isReset) {
      //print('reset');
      getExpiryTime();
      //await Future.delayed(const Duration(seconds: 2));
      // List<String> inTimeParts = expiryTime.split(RegExp(r'[:]'));
      // resethours = int.parse(inTimeParts[0]);
      // resetminutes = int.parse(inTimeParts[1]);
      // // print(resethours);
      // // print(resetminutes);
      // setState(() => duration =
      //     Duration(hours: resethours, minutes: resetminutes, seconds: 0));
    }
  }

  void addTime() {
    if (mounted) {
      setState(() {
        final addSeconds = isCountdown ? -1 : 1;
        final newSeconds = duration.inSeconds + addSeconds;
        if (newSeconds < 0) {
          timer?.cancel();
          updateStatus();
        } else {
          //print(isReset);
          // print(newSeconds);
          //print(isFirstTime);
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
    // if (shouldReload) {
    //   initState();
    // }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Center(
      child: Row(
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
      ),
    );
  }
}
