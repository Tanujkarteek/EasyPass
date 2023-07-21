// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/loading.dart';
import 'package:easypass/components/pending_card.dart';
import 'package:easypass/screens/extend_pending.dart';
import 'package:easypass/screens/profile.dart';
import 'package:easypass/screens/warden_active.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WardenDash extends StatefulWidget {
  const WardenDash({super.key});

  @override
  State<WardenDash> createState() => _WardDashState();
}

class _WardDashState extends State<WardenDash> with TickerProviderStateMixin {
  late AnimationController _controller;

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

  bool isSnapshotActive = false;
  late List<Map<String, dynamic>> pendingData = [];
  late String? hostel;
  bool isLoading = true;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  Future<void> callPendingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userHostel = prefs.getString('hostel');
    setState(() {
      hostel = userHostel;
    });
    // take snapshot of the documents froms logs collection with field status set to active
    var data = await FirebaseFirestore.instance
        .collection('logs')
        .where('status', isEqualTo: 'pending')
        .where('isScanned', isEqualTo: 'no')
        .get();
    // now set qrdata to the value of the field outpass_id of the first document in the snapshot
    //print(data.docs[0]['outpassId']);
    //set state only if snapshot has data
    List<Map<String, dynamic>> tempData = [];
    if (mounted) {
      if (data.docs.isNotEmpty) {
        for (var element in data.docs) {
          tempData.add(element.data());
        }
        setState(() {
          isSnapshotActive = true;
          pendingData = tempData;
        });
      } else {
        setState(() {
          isSnapshotActive = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Call your function here
    callPendingData();

    _controller =
        AnimationController(duration: const Duration(hours: 2), vsync: this);

    //initInfo();
    loader();
  }

  // initInfo() {
  //   var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iosInit = DarwinInitializationSettings();
  //   var initSettings =
  //       InitializationSettings(android: androidInit, iOS: iosInit);
  //   flutterLocalNotificationsPlugin.initialize(initSettings,
  //       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     debugPrint('Got a message whilst in the foreground!');
  //     debugPrint(
  //         'Message data: ${message.notification?.title}\n${message.notification?.body}');

  //     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //       message.notification!.body.toString(),
  //       htmlFormatBigText: true,
  //       contentTitle: message.notification?.title,
  //       htmlFormatContentTitle: true,
  //       //summaryText: 'summary',
  //       htmlFormatSummaryText: true,
  //     );
  //     AndroidNotificationDetails androidPlatformChannelSpecifics =
  //         AndroidNotificationDetails(
  //       'easypass',
  //       'easypass',
  //       importance: Importance.high,
  //       priority: Priority.high,
  //       playSound: true,
  //       styleInformation: bigTextStyleInformation,
  //     );
  //     NotificationDetails platformChannelSpecifics =
  //         NotificationDetails(android: androidPlatformChannelSpecifics);
  //     await flutterLocalNotificationsPlugin.show(
  //       0,
  //       message.notification!.title,
  //       message.notification!.body,
  //       platformChannelSpecifics,
  //       payload: 'Default_Sound',
  //     );
  //   });
  // }

  // void onDidReceiveNotificationResponse(
  //     NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  // }

  Stream<int>? buildCallPendingData() {
    // Return a stream representing the fetched data
    // Example implementation:
    return Stream.periodic(Duration(seconds: 30), (_) {
      if (mounted) {
        callPendingData();
      }
      return 0;
    });
  }

  void loader() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> approveRequest(String outpassId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('name');
    // set status in data to approved
    await FirebaseFirestore.instance.collection('logs').doc(outpassId).update({
      'status': 'approved',
      'handler': userName,
    });
    callPendingData();
  }

  Future<void> denyRequest(String outpassId, String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('name');
    // set status in data to denied
    await FirebaseFirestore.instance.collection('logs').doc(outpassId).update({
      'status': 'denied',
      'denyReason': reason,
      'handler': userName,
    });
    callPendingData();
  }

  final userdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      isLoading: isLoading,
      child: Scaffold(
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.001,
              right: MediaQuery.of(context).size.width * 0.001,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
                child: FloatingActionButton(
                  heroTag: "ht1",
                  elevation: 10.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WardActive(),
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
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.001,
              left: MediaQuery.of(context).size.width * 0.09,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
                child: FloatingActionButton(
                  heroTag: "ht2",
                  elevation: 10.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WardExtendPending(),
                      ),
                    );
                    selectionClick();
                  },
                  backgroundColor: Color.fromRGBO(14, 183, 145, 1),
                  child: Icon(
                    Icons.access_time,
                    size: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
                    text: userdata.read('name').toString(),
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
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            setState(() {
              callPendingData();
            });
          },
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   // ignore: prefer_const_literals_to_create_immutables
                  //   colors: [
                  //     Color.fromRGBO(0, 146, 121, 1),
                  //     Color.fromRGBO(173, 224, 129, 1)
                  //   ],
                  // ),
                  color: Color.fromRGBO(30, 30, 30, 1),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text(
                            'Pending Outpass',
                            style: TextStyle(
                              color: Color.fromRGBO(14, 183, 145, 1),
                              fontSize: 28,
                              fontFamily: 'Cascadia',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              AnimatedSnackBar.material(
                                "Function has not been implemented yet!",
                                type: AnimatedSnackBarType.info,
                                mobileSnackBarPosition:
                                    MobileSnackBarPosition.bottom,
                              ).show(context);
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                'Sort',
                                style: TextStyle(
                                  color: Color.fromRGBO(14, 183, 145, 1),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.07,
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
                          stream: buildCallPendingData(),
                          builder: (context, snapshot) {
                            if (isSnapshotActive == true) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 300.0),
                                child: CustomScrollView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30.0),
                                            child: PendingOutpass(
                                              index: index,
                                              data: pendingData,
                                              //callPendingOutpass: callPendingData,
                                              approveRequest: approveRequest,
                                              denyRequest: denyRequest,
                                              outpassId: pendingData[index]
                                                  ['outpassId'],
                                            ),
                                          );
                                        },
                                        childCount: pendingData.length,
                                      ),
                                      // child: GridView.builder(
                                      //   itemCount: pendingData.length,
                                      //   gridDelegate:
                                      //       const SliverGridDelegateWithFixedCrossAxisCount(
                                      //     crossAxisCount: 1,
                                      //     childAspectRatio: 0.84,
                                      //     mainAxisSpacing: 30,
                                      //   ),
                                      //   itemBuilder: ((context, index) => PendingStudPass(
                                      //         isSnapshotActive: isSnapshotActive,
                                      //         pendingData: pendingData,
                                      //         index: index,
                                      //       )),
                                      // ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      controller: _controller,
                                      'assets/animations/wait.json',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      //width: MediaQuery.of(context).size.width * 0.6,
                                      fit: BoxFit.fitHeight,
                                      onLoaded: (composition) {
                                        _controller
                                          ..duration = composition.duration
                                          ..forward();
                                        //make it go for infinite loop
                                        _controller.repeat();
                                      },
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                    ),
                                    Text(
                                      'No Pending Outpasses!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Cascadia',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
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
}
