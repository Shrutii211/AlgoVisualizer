import 'package:flutter/material.dart';
import 'dart:async'; // Import 'dart:async' to use Timer

import 'Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use Timer.periodic or Timer after for a delay
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: Padding(
          padding: const EdgeInsets.only(left: 90,right: 90,top: 30, bottom: 30),
          child: Container(
            child: Image.asset('assets/algo2.jpeg'),
            ),
        )
        ),
    );
  }
}
