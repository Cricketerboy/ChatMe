import 'dart:developer';
import 'dart:io';

import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/helper/dialogue.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isAnimated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  _handlegoogleBtnClick() {
    Dialogue.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if ((await APIs.userExists())) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          await APIs.userCreate().then((value) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n _signInWithGoogle : $e');
      Dialogue.showSnackBar(context, 'Something Went Wrong (Check Internet !)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat Me'),
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: mq.height * .15,
                right: _isAnimated ? mq.width * .25 : -mq.width * .05,
                width: mq.width * .5,
                child: Image.asset('assets/images/chatappicon3.png')),
            Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .06,
              child: ElevatedButton.icon(
                onPressed: () {
                  _handlegoogleBtnClick();
                },
                icon: Image.asset('assets/images/google.png',
                    height: mq.height * .03),
                label: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(text: 'Login With '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 232, 241, 221),
                  shape: StadiumBorder(),
                  elevation: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
