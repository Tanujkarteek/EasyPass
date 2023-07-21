// ignore_for_file: prefer_const_constructors

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:easypass/components/frostedglass.dart';
import 'package:easypass/components/loading.dart';
import 'package:easypass/components/notification/notif.dart';
import 'package:easypass/screens/past_activities.dart';
import 'package:easypass/screens/pending_request_stud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  GetStorage userdata = GetStorage();
  bool isUser = false;
  bool isloading = false;
  String? type;
  void getType() async {
    type = userdata.read('type').toString();
    if (type == 'student') {
      isUser = true;
    } else {
      isUser = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getType();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      isLoading: isloading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
          elevation: 0.0,
          leadingWidth: MediaQuery.of(context).size.width * 0.22,
          actions: <Widget>[
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
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 30, 30, 1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 140,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        size: 200.0,
                        color: Colors.white,
                        Icons.person,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: userdata.read('name').toString(),
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
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: userdata.read('email').toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(14, 183, 145, 1),
                              fontSize: 16,
                              fontFamily: 'Cascadia',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color.fromRGBO(203, 248, 234, 1),
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(14, 183, 145, 1),
                          ),
                        ),
                        onPressed: () {
                          AnimatedSnackBar.material(
                            "Function has not been implemented yet!",
                            type: AnimatedSnackBarType.info,
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    isUser
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FrostedGlassBox(
                                theHeight:
                                    MediaQuery.of(context).size.height * 0.14,
                                theWidth:
                                    MediaQuery.of(context).size.width * 0.412,
                                theChild: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Past Activities",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Cascadia",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Color.fromRGBO(
                                                    203, 248, 234, 1),
                                                width: 2.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Color.fromRGBO(14, 183, 145, 1),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PastActivities(
                                                userId: userdata
                                                    .read('id')
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                          //NotifHitter().hitUrl();
                                          selectionClick();
                                        },
                                        child: Text(
                                          "View",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Montserrat",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                              ),
                              FrostedGlassBox(
                                theHeight:
                                    MediaQuery.of(context).size.height * 0.14,
                                theWidth:
                                    MediaQuery.of(context).size.width * 0.412,
                                theChild: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Pending Outpass",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Cascadia",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Color.fromRGBO(
                                                    203, 248, 234, 1),
                                                width: 2.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Color.fromRGBO(14, 183, 145, 1),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PendingRequests(
                                                userId: userdata
                                                    .read('id')
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                          selectionClick();
                                        },
                                        child: Text(
                                          "View",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Montserrat",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.14,
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(14, 183, 145, 1),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          FirebaseAuth.instance.signOut();
                          await Future.delayed(Duration(seconds: 5));
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/signin', (route) => false);
                        },
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
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
