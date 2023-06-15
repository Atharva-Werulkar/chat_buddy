import 'dart:convert';
import 'dart:developer';

import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/profile_screen.dart';
import 'package:chat_buddy/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

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
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              user: list[0],
                            )));
              },
              icon: const Icon(Icons.person))
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
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if the data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );

            //if some or all data is Loaded the show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                  padding: EdgeInsets.only(top: size.height * .005),
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ChatCard(
                      user: list[index],
                    );
                  },
                );
              } else {
                return const Center(
                    child: Text(
                  textAlign: TextAlign.center,
                  "No Connection Found !!\n Connect to new people's",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ));
              }
          }
        },
      ),
    );
  }
}
