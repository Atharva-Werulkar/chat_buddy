// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/screens/auth/login_screen.dart';
import 'package:chat_buddy/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      //     statusBarColor: Colors.white,
      //     systemNavigationBarColor: Colors.white));

      //Check if user is already login to not

      if (APIs.auth.currentUser != null) {
        //print User Info

        log("User:- ${APIs.auth.currentUser}");

        //Navigate to Home Screen

        SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
            .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          ),
        );
      } else {
        //Navigate to LoginScreen

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      //Body

      body: Center(
        child: Stack(
          children: [
            Lottie.asset('assets/lottiefiles/hiAnimation.json'),
          ],
        ),
      ),
    );
  }
}
