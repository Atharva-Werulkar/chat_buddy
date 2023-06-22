import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/profile_screen.dart';
import 'package:chat_buddy/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     systemNavigationBarColor: Colors.transparent));
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
            leading: const Icon(
              Icons.home,
              size: 30,
            ),
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
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add_reaction),
            ),
          ),

          // User Cards
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: size.height * .005),
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          _isSearching ? _searchlist.length : _list.length,
                      itemBuilder: (context, index) {
                        return ChatCard(
                          user:
                              _isSearching ? _searchlist[index] : _list[index],
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
        ),
      ),
    );
  }
}
