import 'dart:async';
import 'package:devmusic/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate a delay for demonstration purposes
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the main screen after the splash screen
      Get.off(() => HomeScreen());
    });

    return Scaffold(
      // You can customize the splash screen UI here
      backgroundColor: Colors.orange.shade200,
      body: Center(
        child: Image.asset("img/logo.jpg",height: 40,width: 40,),
      ),
    );
  }
}

