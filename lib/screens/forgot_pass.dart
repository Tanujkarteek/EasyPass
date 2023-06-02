import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  Future Reset_Password() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              content: Text("Link has been sent to you email"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);

      showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
        ),
        body: Column(
          children: [
            Text('Please enter your Email: '),
            Container(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                top: 8,
                bottom: 8,
              ),
              child: TextFormField(
                controller: emailController,

                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                ),
                //textAlign: TextAlign.center,
                enableSuggestions: true,
                decoration: InputDecoration(
                  fillColor: Color.fromRGBO(14, 183, 145, 1),
                  filled: true,
                  focusColor: Color.fromRGBO(0, 53, 88, 0.294),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: "Email",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Email';
                  }
                  return null;
                },
              ),
            ),
            MaterialButton(
              onPressed: () {},
              child: Text('Reset Password'),
            ),
          ],
        ));
  }
}
