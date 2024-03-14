// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:movie_application/login.dart'; // Make sure this is the correct path

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Image.asset(
          'assets/logo.png', 
        ),
      ),
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color(0xFF00000F),
      nextScreen: LoginScreen(), // Navigate to LoginScreen after the splash screen
    );
  }
}
