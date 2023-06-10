import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/screens/home_screen.dart';
import 'package:flutter/material.dart';
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
    Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      //App BAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome To Chat Buddy"),
      ),

      //Body

      body: Stack(
        children: [
          Positioned(
            top: size.height * .15,
            left: size.width * .25,
            width: size.width * .5,
            child: Lottie.asset('assets/lottiefiles/message.json'),
          ),
        ],
      ),
    );
  }
}
