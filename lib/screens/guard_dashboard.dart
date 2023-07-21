// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/active_card.dart';
import 'package:easypass/screens/profile.dart';
import 'package:easypass/screens/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuardDash extends StatefulWidget {
  const GuardDash({Key? key}) : super(key: key);

  @override
  State<GuardDash> createState() => _GuardDashState();
}

class _GuardDashState extends State<GuardDash> with TickerProviderStateMixin {
  late AnimationController _controller;
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  bool isSnapshotActive = false;
  late List<Map<String, dynamic>> activeData = [];

  Future<void> callActiveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userHostel = prefs.getString('hostel');

    // take snapshot of the documents froms logs collection with field status set to active

    var data = await FirebaseFirestore.instance
        .collection('logs')
        .where('status', isEqualTo: 'approved')
        .where('isScanned', isEqualTo: 'yes')
        .where('used', isEqualTo: 'no')
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
          activeData = tempData;
        });
      } else {
        setState(() {
          isSnapshotActive = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Call your function here
    callActiveData();
    _controller =
        AnimationController(duration: const Duration(hours: 2), vsync: this);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Stream<int>? buildCallActiveData() {
    // Return a stream representing the fetched data
    // Example implementation:
    return Stream.periodic(Duration(minutes: 2), (_) {
      if (mounted) {
        callActiveData();
      }
      return 0;
    });
  }

  late double height;

  @override
  Widget build(BuildContext context) {
    if (activeData.length == 1) {
      setState(() {
        height = 400.0;
      });
    } else if (activeData.length == 2) {
      setState(() {
        height = 200.0;
      });
    } else {
      setState(() {
        height = 100.0;
      });
    }
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
        child: FloatingActionButton(
          elevation: 10.0,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScannerPage(),
            ),
          ),
          backgroundColor: Color.fromRGBO(14, 183, 145, 1),
          child: Icon(
            Icons.qr_code_scanner_rounded,
            size: MediaQuery.of(context).size.width * 0.08,
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
              children: const <TextSpan>[
                // TextSpan(
                //   text: 'Hi, ',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 30,
                //     fontFamily: 'Montserrat',
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                TextSpan(
                  text: "EasyPass",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'ShoraiSans',
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
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            callActiveData();
          },
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [Color(0xff009279), Color(0xffADE081)],
                //   begin: FractionalOffset(1.0, 0.0),
                //   end: FractionalOffset(0.0, 1.0),
                // ),
                color: Color.fromRGBO(30, 30, 30, 1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                          if (isSnapshotActive == true) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: height),
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
                                          child: ActiveOutpass(
                                            data: activeData,
                                            index: index,
                                          ),
                                        );
                                      },
                                      childCount: activeData.length,
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
                              height: MediaQuery.of(context).size.height * 0.82,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  Lottie.asset(
                                    controller: _controller,
                                    'assets/animations/ufoNew.json',
                                    height: MediaQuery.of(context).size.height *
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
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  Text(
                                    'No Active Outpasses!',
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
                    // //ActiveOutpass(),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.02,
                    // ),
                    // //ActiveOutpass(),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.02,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
