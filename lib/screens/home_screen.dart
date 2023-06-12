import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_reaction),
        ),
      ),

      // User Cards
      body: ListView.builder(
        padding: EdgeInsets.only(top: size.height * .005),
        physics: const BouncingScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) {
          return const ChatCard();
        },
      ),
    );
  }
}
