import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';

late Size size;

void main() {
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
      home: const LoginScreen(),
    );
  }
}
