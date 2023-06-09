import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App BAR
      appBar: AppBar(
        leading: const Icon(
          Icons.home,
          size: 30,
        ),
        title: const Text("Chat Buddy"),
        actions: [
          //App BAR icons
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),

      //Add Friend Buttom
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_reaction),
        ),
      ),
    );
  }
}
