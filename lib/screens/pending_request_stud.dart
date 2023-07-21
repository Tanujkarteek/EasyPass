// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../components/pending_requests_stud.dart';

class PendingRequests extends StatefulWidget {
  final String userId;

  const PendingRequests({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  String get userId => widget.userId;

  // bool isContentVisible = true;

  // void toggleContentVisibility() {
  //   setState(() {
  //     isContentVisible = !isContentVisible;
  //   });
  // }

  bool isSnapshotActive = false;
  late List<Map<String, dynamic>> pendingRequests = [];

  Future<void> callPendingRequestsData() async {
    // take snapshot of the documents froms logs collection with field status set to active

    var data = await FirebaseFirestore.instance
        .collection('logs')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
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
          pendingRequests = tempData;
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
    debugPrint(userId);
    callPendingRequestsData();
    _controller =
        AnimationController(duration: const Duration(hours: 2), vsync: this);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Stream<int>? buildCallPendingData() {
    // Return a stream representing the fetched data
    // Example implementation:
    return Stream.periodic(Duration(seconds: 10), (_) {
      if (mounted) {
        callPendingRequestsData();
      }
      return 0;
    });
  }

  final userdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        elevation: 0.0,
        leadingWidth: MediaQuery.of(context).size.width * 0.22,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            GestureDetector(
              onTap: () {
                selectionClick();
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.06,
                backgroundColor: Color.fromRGBO(14, 183, 145, 1),
                child: Icon(
                  size: 30.0,
                  color: Colors.white,
                  Icons.close,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: const Text(
          'Pending Requests',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
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
                              text: 'Pending Outpasses',
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
                      stream: buildCallPendingData(),
                      builder: (context, snapshot) {
                        if (isSnapshotActive == true) {
                          return CustomScrollView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      child: PendingRequestCard(
                                        data: pendingRequests[index],
                                        index: index,
                                      ),
                                    );
                                  },
                                  childCount: pendingRequests.length,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  controller: _controller,
                                  'assets/animations/ufoNew.json',
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
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
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                                Text(
                                  'No Pending Requests!',
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
                  //PendingRequestsCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
