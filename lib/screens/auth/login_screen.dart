import 'dart:math';

import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleBtnClick() {
    _signInWithGoogle().then((user) {
      //   log("\nUser: ${user.user}");
      //   log('\nUser Additional Info: ${user.additionalUserInfo}' as num);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
          Positioned(
            bottom: size.height * .15,
            left: size.width * .05,
            width: size.width * .9,
            height: size.height * .07,
            child: ElevatedButton.icon(
              onPressed: () {
                _handleBtnClick();
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: size.height * .03,
              ),
              label: RichText(
                text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: [
                      TextSpan(text: ' Login With '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
