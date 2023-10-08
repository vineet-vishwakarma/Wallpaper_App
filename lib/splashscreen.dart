import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/wallpaper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Wallpaper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/splashscreen.png"),
    );
  }
}
