// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unused_import

//import 'package:easypass/screens/non_using_pages/dummy_stud.dart';
import 'package:easypass/components/timer.dart';
import 'package:easypass/screens/non_using_pages/dummy_warden.dart';
import 'package:easypass/screens/guard_dashboard.dart';
import 'package:easypass/screens/outpass_request.dart';
import 'package:easypass/screens/past_activities.dart';
import 'package:easypass/screens/profile.dart';
import 'package:easypass/screens/signin.dart';
import 'package:easypass/screens/stud_dashboard.dart';
import 'package:easypass/screens/welcome.dart';
import 'package:easypass/screens/ward_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();

  runApp(EasyPass());
}

// ignore: must_be_immutable
class EasyPass extends StatelessWidget {
  EasyPass({Key? key}) : super(key: key);
  //This main color is used in the whole app
  static const MaterialColor customSwatch = MaterialColor(0xFF0EB791, {
    50: Color(0xFFE0F5F0),
    100: Color(0xFFB3ECE2),
    200: Color(0xFF80E3D4),
    300: Color(0xFF4DDAC6),
    400: Color(0xFF26D1B9),
    500: Color(0xFF0EB791), // Primary color
    600: Color(0xFF0B9D7E),
    700: Color(0xFF09896B),
    800: Color(0xFF067657),
    900: Color(0xFF035343),
  });

  late String name;
  late String rollno;
  late String email;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? 'name';
    rollno = prefs.getString('rollno') ?? 'rollno';
    email = prefs.getString('email') ?? 'email';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/welcome': (context) => Welcome(),
        '/signin': (context) => SignIN(),
        '/stud_dash': (context) => StudDash(),
        '/outpass_request': (context) => RequestPage(),
        '/ward_dash': (context) => WardenDash(),
        '/guard_dash': (context) => GuardDash(),
        '/profile': (context) => ProfilePage(),
      },
      // remove debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body: MainPage(),
        body: NotifInit(),
      ),
      theme: ThemeData(
        primarySwatch: EasyPass.customSwatch,
        brightness: Brightness.dark,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: EasyPass.customSwatch.shade100,
          selectionColor: EasyPass.customSwatch.shade100,
          selectionHandleColor: EasyPass.customSwatch.shade100,
        ),
      ),
    );
  }
}

class NotifInit extends StatefulWidget {
  const NotifInit({super.key});

  @override
  State<NotifInit> createState() => _NotifInitState();
}

class _NotifInitState extends State<NotifInit> {
  String? userToken = '';

  final userdata = GetStorage();

  //getting token from firebase for each user to get neotification
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      userToken = token;
      debugPrint("Token: $token");
      userdata.write('token', userToken);
    });
  }

  //requesting permission for notification
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Initializing notification
  initInfo() {
    var androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInit = DarwinInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint(
          'Message data: ${message.notification?.title}\n${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification?.title,
        htmlFormatContentTitle: true,
        //summaryText: 'summary',
        htmlFormatSummaryText: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'easypass',
        'easypass',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        styleInformation: bigTextStyleInformation,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    });
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    requestPermission();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}

// ignore: must_be_immutable
class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);
  late String name;
  late String rollno;
  late String email;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? 'name';
    rollno = prefs.getString('rollno') ?? 'rollno';
    email = prefs.getString('email') ?? 'email';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: checkLog(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 1) {
                      //return ProfilePage();
                      return StudDash();
                      //return PastActivities();
                      //return CountdownTimer();
                    } else if (snapshot.data == 2) {
                      //return DWardPage();
                      return WardenDash();
                    } else if (snapshot.data == 3) {
                      //return ProfilePage();
                      return GuardDash();
                      //return DGuardPage();
                    } else {
                      return Welcome();
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Welcome();
            }
          },
        ),
      );

  //Checking if user is logged in or not and what type of user is logged in
  Future checkLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString('type') ?? 'student';
    if (type == 'student') {
      return 1;
    } else if (type == 'warden') {
      return 2;
    } else if (type == 'guard') {
      return 3;
    } else {
      return 4;
    }
  }
}
