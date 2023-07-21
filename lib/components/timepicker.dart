// import 'package:easypass/screens/outpass_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
//import timevalue

class NumberOverlay extends StatefulWidget {
  final ValueChanged<String>? onCloseOverlay;
  //final ValueChanged<String>? onDismissOverlay;

  const NumberOverlay({
    Key? key,
    this.onCloseOverlay,
  }) : super(key: key);

  @override
  State<NumberOverlay> createState() => _NumberOverlayState();
}

class _NumberOverlayState extends State<NumberOverlay> {
  int hour = 12;
  int minute = 0;
  var timeFormat = "";
  static Future<void> selectionClick() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.414,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          // Close the overlay when tapping outside the content
          //Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      //   "Pick Your Time! ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} ${timeFormat}",
                      //   style: const TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 18),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 20, vertical: 10),
                          // decoration: BoxDecoration(
                          //     color: Colors.black87,
                          //     borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NumberPicker(
                                minValue: 1, // Minimum value is set to 1
                                maxValue: 12, // Maximum value is set to 12
                                value: hour,
                                infiniteLoop: true,
                                itemWidth:
                                    MediaQuery.of(context).size.width * 0.3,
                                itemHeight:
                                    MediaQuery.of(context).size.height * 0.08,
                                onChanged: (value) {
                                  setState(() {
                                    hour = value;
                                    timeFormat = "";
                                  });
                                  selectionClick();
                                },
                                textStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 20),
                                selectedTextStyle: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.white),
                                    bottom: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              NumberPicker(
                                minValue: 0,
                                maxValue: 59,
                                value: minute,
                                zeroPad: true,
                                infiniteLoop: true,
                                itemWidth:
                                    MediaQuery.of(context).size.width * 0.3,
                                itemHeight:
                                    MediaQuery.of(context).size.height * 0.08,
                                onChanged: (value) {
                                  setState(() {
                                    minute = value;
                                    timeFormat = "";
                                  });
                                  selectionClick();
                                },
                                textStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 20),
                                selectedTextStyle: const TextStyle(
                                    color: Colors.white, fontSize: 35),
                                decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                        color: Colors.white,
                                      ),
                                      bottom: BorderSide(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                timeFormat = "AM";
                              });
                              selectionClick();
                              widget.onCloseOverlay?.call(
                                  "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} $timeFormat");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: timeFormat == "AM"
                                    ? const Color(0xFF0EB791)
                                    : Colors.grey.shade700,
                                border: Border.all(
                                  color: timeFormat == "AM"
                                      ? const Color.fromRGBO(52, 191, 127, 1)
                                      : Colors.grey.shade700,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "AM",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                timeFormat = "PM";
                              });
                              selectionClick();
                              widget.onCloseOverlay?.call(
                                  "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} $timeFormat");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: timeFormat == "PM"
                                    ? const Color(0xFF0EB791)
                                    : Colors.grey.shade700,
                                border: Border.all(
                                  color: timeFormat == "PM"
                                      ? const Color.fromRGBO(52, 191, 127, 1)
                                      : Colors.grey.shade700,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "PM",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // .setTime.value = "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} ${timeFormat}";
                      //     // set value to _myValueNotifier
                      //     _myValueNotifier.value =
                      //         "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} ${timeFormat}";
                      //     // set value to _myOverlayNotifier
                      //     _myOverlayNotifier.value = false;
                      //   },
                      //   child: const Text("Done"),
                      // )
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
