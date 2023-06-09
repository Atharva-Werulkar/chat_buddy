import 'package:chat_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          Positioned(
            top: size.height * .35,
            left: size.width * .25,
            width: size.width * .5,
            child: Lottie.asset('assets/lottiefiles/message.json'),
          )
        ],
      ),
    );
  }
}
