import 'package:chatapp/apis/apis.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/screens/auth/loadaing_screen.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      //exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Loading()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: mq.height * .22,
                right: mq.width * .25,
                width: mq.width * .5,
                child: Image.asset('assets/images/chatappicon3.png')),
            Positioned(
                bottom: mq.height * .15,
                width: mq.width,
                child: Text(
                  'MADE IN INDIA WITH ❤️',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
