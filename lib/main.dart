import 'package:chat_buddy/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late Size size;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Buddy',
      theme: ThemeData(
        //App BAR THEME
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 5,
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
            iconTheme: IconThemeData(color: Colors.black)),
        useMaterial3: true,
      ),

      //Main App
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
