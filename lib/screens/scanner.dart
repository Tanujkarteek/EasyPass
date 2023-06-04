import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypass/components/cameraoverlay.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String qr1 = "";
  bool _isScanned = false;
  bool _isFlashOn = false;
  MobileScannerController controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  void closeScreen() {
    _isScanned = false;
  }

  Future<void> passActivator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // ignore: unused_local_variable
    var data =
        await FirebaseFirestore.instance.collection('logs').doc(qr1).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          if (data['status'] == 'approved' && data['isScanned'] == 'no') {
            //create a document in active with doc id as qr1
            FirebaseFirestore.instance
                .collection('active')
                .doc(qr1)
                .set({'status': 'active', 'logId': qr1});
            FirebaseFirestore.instance
                .collection('logs')
                .doc(qr1)
                .update({'isScanned': 'yes'});
            FirebaseFirestore.instance
                .collection('logs')
                .doc(qr1)
                .update({'guard': userId});
            AnimatedSnackBar.material(
              'Pass activated',
              type: AnimatedSnackBarType.success,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            ).show(context);
          } else if (data['status'] == 'approved' &&
              data['isScanned'] == 'yes') {
            //delete the document in active with doc id as qr1
            FirebaseFirestore.instance.collection('active').doc(qr1).delete();
            FirebaseFirestore.instance
                .collection('logs')
                .doc(qr1)
                .update({'status': 'used'});
            AnimatedSnackBar.material(
              'Pass is deactivated',
              type: AnimatedSnackBarType.info,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            ).show(context);
          } else if (data['status'] == 'used' && data['isScanned'] == 'yes') {
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
            print("No pass found random data");
            AnimatedSnackBar.material(
              'Pass not found',
              type: AnimatedSnackBarType.error,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            ).show(context);
          }
        } else if (!documentSnapshot.exists) {
          //print("No pass found random data");
          AnimatedSnackBar.material(
            'Pass not found',
            type: AnimatedSnackBarType.error,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        }
      },
    );
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

                              Navigator.pop(context);
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
