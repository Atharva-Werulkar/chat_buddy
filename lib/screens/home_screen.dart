import 'dart:developer';

import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/profile_screen.dart';
import 'package:chat_buddy/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_buddy/components/dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUser> _list = [];

//for storing sreached items
  final List<ChatUser> _searchlist = [];

  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        //resume -- active or online
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        //pause -- inactive or offline
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //to hide keyboard when user tap on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //App BAR
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email, ...'),
                    autofocus: true,
                    //when the is text is changed then update the search list
                    onChanged: (val) {
                      //search logic
                      _searchlist.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchlist.add(i);
                        }

                        setState(() {
                          _searchlist;
                        });
                      }
                    },
                  )
                : const Text("Chat Buddy"),
            actions: [
              //App BAR icons
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching ? Icons.clear : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: const Icon(Icons.person))
            ],
          ),

          //Add Friend Buttom
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              child: const Icon(Icons.message_rounded),
            ),
          ),

          // User Cards
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),

            //get id of known users
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
                  return StreamBuilder(
                    stream: APIs.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those users whose id is in my_users collection
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if the data is loading

                        case ConnectionState.waiting:
                        case ConnectionState.none:

                        //if some or all data is Loaded the show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              padding: EdgeInsets.only(top: size.height * .005),
                              physics: const BouncingScrollPhysics(),
                              itemCount: _isSearching
                                  ? _searchlist.length
                                  : _list.length,
                              itemBuilder: (context, index) {
                                return ChatCard(
                                  user: _isSearching
                                      ? _searchlist[index]
                                      : _list[index],
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
                              ),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

//add friend
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Add Friend'),
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  prefixIcon: const Icon(Icons.email_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              //action
              actions: [
                //cancel button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        //close dialog
                        Navigator.pop(context);
                      },
                      child: const Text('Cancle'),
                    ),
                    //Add button
                    MaterialButton(
                      onPressed: () {
                        //close dialog
                        Navigator.pop(context);
                        if (email.isNotEmpty) {
                          APIs.addChatUser(email).then((value) {
                            if (value) {
                              Dialogs.showSnakbar(context, 'User Added');
                            } else {
                              Dialogs.showSnakbar(context, 'User Not Found');
                            }
                          });
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                )
              ],
            ));
  }
}
