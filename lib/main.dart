// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unused_import

//import 'package:easypass/screens/non_using_pages/dummy_stud.dart';
import 'package:easypass/screens/dummy_warden.dart';
import 'package:easypass/screens/outpass_request.dart';
import 'package:easypass/screens/signin.dart';
import 'package:easypass/screens/stud_dashboard.dart';
import 'package:easypass/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/dummy_guard.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EasyPass());
}

class EasyPass extends StatelessWidget {
  EasyPass({Key? key}) : super(key: key);
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/welcome': (context) => Welcome(),
        '/signin': (context) => SignIN(),
        '/stud_dash': (context) => StudDash(),
        '/outpass_request': (context) => RequestPage(),
        '/dummy_ward': (context) => DWardPage(),
        '/dummy_guard': (context) => DGuardPage(),
      },
      // remove debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body: MainPage(),
        body: MainPage(),
      ),
      theme: ThemeData(
        primarySwatch: customSwatch,
        brightness: Brightness.dark,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: customSwatch.shade100,
          selectionColor: customSwatch.shade100,
          selectionHandleColor: customSwatch.shade100,
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

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
                      return StudDash();
                    } else if (snapshot.data == 2) {
                      return DWardPage();
                    } else if (snapshot.data == 3) {
                      return DGuardPage();
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
