import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/cameraoverlay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  String qr1 = "";
  bool _isScanned = false;
  bool _isFlashOn = false;
  //bool isAlreadyActive = false;
  late String userId;
  MobileScannerController controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  void closeScreen() {
    _isScanned = false;
  }

  // Future<void> checkActive() async {
  //   //create a instance of logs collection and get the document with id of qr1 and assign the value from user_id to a local variable
  //   DocumentSnapshot doc =
  //       await FirebaseFirestore.instance.collection('logs').doc(qr1).get();
  //   var data = doc.data() as Map<String, dynamic>;
  //   userId = data['user_id'];
  //   late var logId;

  //   await FirebaseFirestore.instance
  //       .collection('active')
  //       .doc(userId)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     // create a document snapshot of active collection and get the document with id of userId and assign the value from logId to a local variable
  //     if (documentSnapshot.exists) {
  //       var active = documentSnapshot.data() as Map<String, dynamic>;
  //       logId = active['logId'];
  //     }
  //     if (documentSnapshot.exists && logId != qr1) {
  //       //isAlreadyActive = true;
  //       AnimatedSnackBar.material(
  //         'One Pass is already active\nClose the previous pass to activate new pass',
  //         type: AnimatedSnackBarType.error,
  //         mobileSnackBarPosition: MobileSnackBarPosition.bottom,
  //       ).show(context);
  //     }
  //     if (documentSnapshot.exists && logId == qr1) {
  //       debugPrint("hehe");
  //       //isAlreadyActive = false;
  //       passActivator();
  //       AnimatedSnackBar.material(
  //         'Pass is deactivated',
  //         type: AnimatedSnackBarType.info,
  //         mobileSnackBarPosition: MobileSnackBarPosition.bottom,
  //       ).show(context);
  //     } else {
  //       debugPrint("hehe");
  //       //isAlreadyActive = true;
  //       passActivator();
  //     }
  //   });
  // }

  Future<void> passActivator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userGuardId = prefs.getString('id');

    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('logs').doc(qr1).get();
    var data = doc.data() as Map<String, dynamic>;
    userId = data['user_id'];
    late String logId;

    DocumentSnapshot documentSnapshot1 =
        await FirebaseFirestore.instance.collection('active').doc(userId).get();
    if (documentSnapshot1.exists) {
      var active = documentSnapshot1.data() as Map<String, dynamic>;
      logId = active['logId'];
    }

    // var data =
    await FirebaseFirestore.instance.collection('logs').doc(qr1).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot1.exists && logId != qr1) {
            //isAlreadyActive = true;
            AnimatedSnackBar.material(
              'One Pass is already active\nClose the previous pass to activate new pass',
              type: AnimatedSnackBarType.error,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            ).show(context);
          }
          var data = documentSnapshot.data() as Map<String, dynamic>;
          //get the time of the pass
          var time = data['leaveTime'];
          var date = data['date'];
          var userId = data['user_id'];

          //get the current time in 24 hour format
          var now = DateTime.now();
          //take day from now
          var day = now.day;
          //take month from now
          var month = now.month;
          //take year from now
          var year = now.year;
          // date is in form of 09-06-2023 converte day month and year to int
          var date1 = date.split("-");
          var day1 = int.parse(date1[0]);
          var month1 = int.parse(date1[1]);
          var year1 = int.parse(date1[2]);

          //take hour from now
          var hour = now.hour;
          //take minute from now
          var minute = now.minute;
          // time is in form of 02:00 AM converte hour and minute to int and make it in 24 hour format
          var time1 = time.split(":");
          var hour1 = int.parse(time1[0]);
          var minute1 = int.parse(time1[1].split(" ")[0]);
          var ampm = time1[1].split(" ")[1];
          if (ampm == "PM") {
            hour1 = hour1 + 12;
          }
          // print("$hour $minute $day $month $year");
          // print("$hour1 $minute1 $day1 $month1 $year1");
          //check if the current time is greater than the pass time
          if (hour >= hour1 &&
              minute >= minute1 &&
              day == day1 &&
              month == month1 &&
              year == year1) {
            if (data['status'] == 'approved' && data['isScanned'] == 'no') {
              FirebaseFirestore.instance
                  .collection('active')
                  .doc(userId)
                  .set({'status': 'active', 'logId': qr1});
              FirebaseFirestore.instance
                  .collection('logs')
                  .doc(qr1)
                  .update({'isScanned': 'yes', 'guard': userGuardId});
              AnimatedSnackBar.material(
                'Pass activated',
                type: AnimatedSnackBarType.success,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            } else if (data['status'] == 'approved' &&
                data['isScanned'] == 'yes' &&
                documentSnapshot1.exists &&
                logId == qr1) {
              //delete the document in active with doc id as qr1
              FirebaseFirestore.instance
                  .collection('active')
                  .doc(userId)
                  .delete();
              FirebaseFirestore.instance
                  .collection('logs')
                  .doc(qr1)
                  .update({'used': 'yes'});
              AnimatedSnackBar.material(
                'Pass is deactivated',
                type: AnimatedSnackBarType.info,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            } else if (data['status'] == 'approved' &&
                data['isScanned'] == 'yes' &&
                data['used'] == 'yes') {
              AnimatedSnackBar.material(
                'Pass is already used',
                type: AnimatedSnackBarType.info,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            } else if (data['status'] == 'pending') {
              AnimatedSnackBar.material(
                'Pass is not approved',
                type: AnimatedSnackBarType.info,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            } else {
              //print("No pass found random data");
              AnimatedSnackBar.material(
                'Pass not found',
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            }
          } else {
            AnimatedSnackBar.material(
              "Pass can't be activated before the time",
              type: AnimatedSnackBarType.error,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            ).show(context);
          }
        } else if (!documentSnapshot.exists) {
          //print("No pass found random data");
          AnimatedSnackBar.material(
            'No pass found random data',
            type: AnimatedSnackBarType.error,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        }
      },
    );
  }

  Future<void> delayedPop(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
              controller.toggleTorch();
            },
            icon: Icon(
              _isFlashOn ? Icons.flash_off : Icons.flash_on,
              color: Colors.grey.shade300,
            ),
          ),
        ],
        //toolbarHeight: MediaQuery.of(context).size.height * 0.08,
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
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(14, 183, 145, 1),
                child: Icon(
                  size: 36.0,
                  color: Colors.white,
                  Icons.close,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: const Text(
          'Scanner',
          style: TextStyle(
            fontSize: 28,
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
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [Color(0xff009279), Color(0xffADE081)],
              //   begin: FractionalOffset(1.0, 0.0),
              //   end: FractionalOffset(0.0, 1.0),
              // ),
              color: Color.fromRGBO(30, 30, 30, 1),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: const TextSpan(
                          text: 'Place the QR code in the area',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Cascadia',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: const TextSpan(
                          text: 'Scanning will start automatically',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cascadia',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: controller,
                        onDetect: (capture) {
                          if (!_isScanned) {
                            Barcode? barcode = capture.barcodes.first;
                            if (barcode != null) {
                              debugPrint('QR found! ${barcode.rawValue}');
                              _isScanned = true;
                              String? qr = barcode.rawValue;

                              if (qr == null) {
                                setState(() {
                                  qr1 = "No QR code found";
                                });
                              } else {
                                setState(() {
                                  qr1 = qr;
                                });
                              }
                              passActivator();
                              // AnimatedSnackBar.material(
                              //   qr1,
                              //   type: AnimatedSnackBarType.error,
                              //   mobileSnackBarPosition:
                              //       MobileSnackBarPosition.bottom,
                              // ).show(context);

                              delayedPop(context);
                            }
                            // final List<Barcode> barcodes = capture.barcodes;
                            // //final Uint8List? image = capture.image;
                            // for (final barcode in barcodes) {
                            //   debugPrint('QR found! ${barcode.rawValue}');
                            //   _isScanned = true;
                            //   String? qr = barcode.rawValue;
                            //   String qr1 = "";
                            //   if (qr == null) {
                            //     setState(() {
                            //       qr1 = "No QR code found";
                            //     });
                            //   } else {
                            //     setState(() {
                            //       qr1 = qr;
                            //     });
                            //   }
                            //   AnimatedSnackBar.material(
                            //     qr1,
                            //     type: AnimatedSnackBarType.error,
                            //     mobileSnackBarPosition:
                            //         MobileSnackBarPosition.bottom,
                            //   ).show(context);
                            //   //closeScreen();
                            //   Navigator.pop(context);
                            // }
                          }
                        },
                      ),
                      // Overlay(
                      //   initialEntries: [
                      //     OverlayEntry(
                      //       builder: (context) {
                      //         return CustomPaint(
                      //           painter: OverlayPainter(),
                      //           size: Size.infinite,
                      //         );
                      //       },
                      //     ),
                      //   ],
                      // ),
                      const QRScannerOverlay(
                        //overlayColour: Colors.black.withOpacity(0.8),
                        overlayColour: Color.fromRGBO(30, 30, 30, 1),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Developed by team ',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'ShoraiSans',
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'EasyPass',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'ShoraiSans',
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(14, 183, 145, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rect = Rect.fromLTWH(
      size.width *
          0.2, // Adjust the position and size of the rectangle as needed
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.6,
    );

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) => false;
}
