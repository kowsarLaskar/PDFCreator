import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdfcreator/onboarding_page.dart';
import 'package:pdfcreator/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkIfOnboardingViewed();
  }

  Future<void> _checkIfOnboardingViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isViewed = prefs.getBool('onboardingViewed') ?? false;

    Timer(const Duration(seconds: 3), () {
      if (isViewed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover, // Ensures the image covers the entire screen
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Center(
  //       child: Image.asset(
  //         'assets/images/splash.png',
  //         width: 500,
  //         height: 1200,
  //       ),
  //     ),
  //   );
  // }
}
