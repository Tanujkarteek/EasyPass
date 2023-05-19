// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unused_import

import 'package:easypass/screens/dummy_stud.dart';
import 'package:easypass/screens/dummy_warden.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/welcome': (context) => Welcome()},
      // remove debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MainPage(),
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
                      return DStudPage();
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
