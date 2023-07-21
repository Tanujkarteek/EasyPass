// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/active_stud_outpass.dart';
import 'package:easypass/components/loading.dart';
import 'package:easypass/components/notification/notif.dart';
import 'package:easypass/components/pending_stud_outpass.dart';
import 'package:easypass/screens/outpass_request.dart';
import 'package:easypass/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_rectween.dart';
import '../components/hero_dialog_route.dart';

class StudDash extends StatefulWidget {
  const StudDash({
    super.key,
  });

  @override
  State<StudDash> createState() => _StudDashState();
}

class _StudDashState extends State<StudDash>
    with SingleTickerProviderStateMixin {
  final userdata = GetStorage();
  late AnimationController _controller;
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  // All Variables
  // Control Variable
  bool isSnapshotActive = false;
  bool isSnapshotActiveActive = false;
  bool limitTime = true;
  bool isNearExpiry = false;
  bool isSnackBarShowing = false;
  bool isReset = false;
  String name = '';

  void reset() {
    // Create a timer that repeats every specified duration
    Timer.periodic(Duration(seconds: 15), (Timer timer) {
      // Call the function
      setState(() {
        isReset = false;
      });
    });
  }

  // Data Variables
  late List<Map<String, dynamic>> pendingData = [];
  late List<Map<String, dynamic>> activeData = [];
  // Timer Variable
  Timer? _timer;
  bool timerShouldReload = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //Calling the data from backend each time when for the first time the data is called
    callActiveData();
    callPendingData();
    //For reset variable timer reset
    startTimer();
    loader();
    reset();
    setState(() {
      name = userdata.read('name').toString().split(' ')[0];
    });
    _controller =
        AnimationController(duration: const Duration(hours: 2), vsync: this);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void loader() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  //This is for the expiry time check to enable the extension option when it is less than 30 mins
  void checkExpiry() async {
    var currentTime = DateTime.now();
    String time = DateFormat('h:mm a').format(currentTime);
    List<String> currentTimeParts = time.split(RegExp(r'[:\s]'));
    var hourNow = int.parse(currentTimeParts[0]);
    var minNow = int.parse(currentTimeParts[1]);
    // add a delay for 5 secs
    await Future.delayed(const Duration(seconds: 5));
    String inTime = activeData[0]['inTime'];
    List<String> inTimeParts = inTime.split(RegExp(r'[:\s]'));
    int inTimeHour = int.parse(inTimeParts[0]);
    int inTimeMinute = int.parse(inTimeParts[1]);
    int hourDiff = inTimeHour - hourNow;
    int minDiff = inTimeMinute - minNow;
    if (minDiff < 0) {
      hourDiff = hourDiff - 1;
      minDiff = minDiff + 60;
    }
    // debugPrint("mindiff $minDiff");
    // debugPrint("hourdiff $hourDiff");
    if (hourDiff == 0 && minDiff <= 30) {
      setState(() {
        isNearExpiry = true;
      });
    } else {
      setState(() {
        isNearExpiry = false;
      });
    }
  }

  //This is for checking expiry in every 5 seconds and then calling the checkExpiry function
  void startTimer() {
    const duration = Duration(seconds: 5);
    setState(() {
      if (mounted) {
        _timer = Timer.periodic(duration, (timer) {
          setState(() {
            timerShouldReload = true;
          });
          if (activeData.isNotEmpty) {
            checkExpiry();
          }
          //debugPrint('iam called');
        });
      }
    });
  }

  //This is a function to call the pending data from the backend
  Future<void> callPendingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // take snapshot of the documents froms logs collection with field status set to active
    var data = await FirebaseFirestore.instance
        .collection('logs')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'approved')
        .where('isScanned', isEqualTo: 'no')
        .where('used', isEqualTo: 'no')
        .get();

    //It get stored in a list of map
    List<Map<String, dynamic>> tempData1 = [];
    if (mounted) {
      if (data.docs.isNotEmpty) {
        for (var element in data.docs) {
          tempData1.add(element.data());
        }
        setState(() {
          isSnapshotActive = true;
          pendingData = tempData1;
        });
      } else {
        setState(() {
          isSnapshotActive = false;
        });
      }
    }
  }

  //This is a function to call the active data from the backend
  Future<void> callActiveData() async {
    //print("hehe");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');

    var data = await FirebaseFirestore.instance
        .collection('logs')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'approved')
        .where('isScanned', isEqualTo: 'yes')
        .where('used', isEqualTo: 'no')
        .get();
    List<Map<String, dynamic>> tempData = [];

    //It get stored in a list of map
    if (mounted) {
      if (data.docs.isNotEmpty) {
        for (var element in data.docs) {
          tempData.add(element.data());
        }
        setState(() {
          isSnapshotActiveActive = true;
          activeData = tempData;
        });
      } else {
        setState(() {
          isSnapshotActiveActive = false;
        });
      }
    }
  }

  //This is a stream builder to call the pending data from the backend in every 5 mins
  Stream<int>? buildCallPendingData() {
    // Return a stream representing the fetched data
    // Example implementation:
    return Stream.periodic(Duration(minutes: 5), (_) {
      if (mounted) {
        callPendingData();
      }
      return 0;
    });
  }

  //This is a stream builder to call the active data from the backend in every 15 mins
  Stream<int>? buildCallActiveData() {
    // Return a stream representing the fetched data
    // Example implementation:
    return Stream.periodic(Duration(minutes: 15), (_) {
      if (mounted) {
        callActiveData();
      }
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Unfocus the keyboard when tapped outside the textfield
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      //Main widget function with LoadingOverlayWidget
      child: LoadingOverlayWidget(
        isLoading: isLoading,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
            child: FloatingActionButton(
              elevation: 10.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestPage(),
                  ),
                );
                selectionClick();
              },
              backgroundColor: Color.fromRGBO(14, 183, 145, 1),
              child: Icon(
                Icons.add,
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
                      //This will render name dynamically
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
            child: RefreshIndicator(
              //Rerfresh indicator to refresh the data
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                callActiveData();
                callPendingData();
                checkExpiry();
                setState(() {
                  isReset = true;
                });
              },
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 30, 30, 1),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
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
                                    text: 'Active Outpass',
                                    style: TextStyle(
                                      color: Color.fromRGBO(14, 183, 145, 1),
                                      fontSize: 28,
                                      fontFamily: 'Cascadia',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            //Extension option when the expiry time is less than 30 mins
                            isNearExpiry
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        HeroDialogRoute(
                                          builder: (context) {
                                            return _RequestTimePopUpCard(
                                              activeData: activeData,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    //This is a custom Hero animation for a custom dialog box
                                    child: Hero(
                                      tag: _heroOpenDialog,
                                      createRectTween: (begin, end) {
                                        return CustomRectTween(
                                            begin: begin, end: end);
                                      },
                                      child: Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Color.fromRGBO(
                                                  14, 183, 145, 1),
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              child: Icon(
                                                Icons.access_time_rounded,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.08,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Color.fromRGBO(100, 100, 100, 1),
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        //Animated snackbar to show the extension option is only available 30 mins prior to expiry
                                        child: IconButton(
                                          onPressed: () {
                                            if (!isSnackBarShowing) {
                                              isSnackBarShowing = true;
                                              AnimatedSnackBar.material(
                                                'Only available 30 mins prior to expiry',
                                                type:
                                                    AnimatedSnackBarType.error,
                                                mobileSnackBarPosition:
                                                    MobileSnackBarPosition
                                                        .bottom,
                                              ).show(context).then((_) {
                                                setState(() {
                                                  isSnackBarShowing = false;
                                                });
                                              });
                                            }
                                            //NotifHitter().hitUrl();
                                          },
                                          icon: Icon(
                                            Icons.access_time_rounded,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.08,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        SizedBox(
                          //height: MediaQuery.of(context).size.height * 0.54,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: StreamBuilder<Object>(
                            stream: buildCallActiveData(),
                            builder: (context, snapshot) {
                              if (isSnapshotActiveActive == true) {
                                return CustomScrollView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  slivers: [
                                    //This is a custom scroll view to show the active outpass
                                    //This is an SliverList to show the active outpass in a list
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30.0),
                                            child: ActiveStudPass(
                                              index: index,
                                              activeData: activeData,
                                              isReset: isReset,
                                            ),
                                          );
                                        },
                                        childCount: 1,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.54,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //This is a lottie animation to show when there is no active outpass
                                      Lottie.asset(
                                        controller: _controller,
                                        'assets/animations/ufoOrj.json',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        fit: BoxFit.fitHeight,
                                        onLoaded: (composition) {
                                          _controller
                                            ..duration = composition.duration
                                            ..forward();
                                          //make it go for infinite loop
                                          _controller.repeat();
                                        },
                                      ),
                                      const Spacer(),
                                      const Text(
                                        "Nothing to see here now!",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(139, 195, 74, 1),
                                          fontSize: 20,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
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
                                    text: 'Upcoming Outpass',
                                    style: TextStyle(
                                      color: Color.fromRGBO(14, 183, 145, 1),
                                      fontSize: 28,
                                      fontFamily: 'Cascadia',
                                      fontWeight: FontWeight.w700,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: StreamBuilder<Object>(
                            stream: buildCallPendingData(),
                            builder: (context, snapshot) {
                              if (isSnapshotActive == true) {
                                return CustomScrollView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  slivers: [
                                    //This is a custom scroll view to show the pending outpass
                                    //This is an SliverList to show the pending outpass in a list
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30.0),
                                            child: PendingStudPass(
                                              pendingData: pendingData,
                                              index: index,
                                            ),
                                          );
                                        },
                                        childCount: pendingData.length,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        textAlign: TextAlign.center,
                                        "Request a Outpass now!\nClick on the + button",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'cascadia',
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _heroOpenDialog = 'openDialog';

// ignore: must_be_immutable
class _RequestTimePopUpCard extends StatelessWidget {
  List<Map<String, dynamic>> activeData = [];

  _RequestTimePopUpCard({
    key,
    required this.activeData,
  }) : super(key: key);

  //This is to update the extension request in the backend
  void extendRequest(int period, String reason) async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(activeData[0]['outpassId'])
        .update(
      {
        'extended': 'pending',
        'extendPeriod': period,
        'extendReason': reason,
        // 'inTime': newInTime,
      },
    );
  }

  final TextEditingController _reason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: _heroOpenDialog,
        child: Material(
          elevation: 2,
          color: Color.fromRGBO(14, 110, 89, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'Request Time Extension',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: _reason,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Reason',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Cascadia',
                          //fontWeight: FontWeight.w700,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
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
                            extendRequest(30, _reason.text);
                            Navigator.pop(context);
                          },
                          child: Text(
                            '30 min',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
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
                            extendRequest(60, _reason.text);
                            Navigator.pop(context);
                          },
                          child: Text(
                            '1 Hour',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
