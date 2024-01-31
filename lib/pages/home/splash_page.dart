import 'dart:async';

import 'package:flutter/material.dart';

import '../pages.dart';

class SplashPage extends StatefulWidget {
  static String routeName = "splash";

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => __SplashPageState();
}

class __SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate the splash screen
    Timer(const Duration(seconds: 2), () {
      // Navigate to the main screen after the delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // You can customize the splash screen UI here
      body: Center(
        child: FlutterLogo(size: 200),
      ),
    );
  }
}