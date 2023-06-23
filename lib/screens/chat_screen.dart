import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/models/message.dart';
import 'package:chat_buddy/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for staring all messages
  List<Message> _list = [];

//for handling message text change
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        // backgroundColor: Colors.white,

        //body
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if the data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: SizedBox(),
                      );

                    //if some or all data is Loaded the show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: size.height * .005),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(
                              message: _list[index],
                            );
                          },
                          itemCount: _list.length,
                        );
                      } else {
                        return const Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          "Say Hi!! 👋",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ));
                      }
                  }
                },
              ),
            ),
            _chatBody(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        //back button
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        //user profile
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size.height * .3),
            child: CachedNetworkImage(
              width: size.height * .05,
              height: size.height * .05,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
        ),

        //for adding some space
        const SizedBox(
          width: 10,
        ),

        //user name and last seen

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //user name
            Text(
              widget.user.name,
              style: const TextStyle(fontSize: 18),
            ),
            //last seen
            const Text(
              'last seen today at 12:00',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        )
      ],
    );
  }

  Widget _chatBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * .01, horizontal: size.width * .020),
      child: Row(
        children: [
          //input field and buttons

          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions,
                      size: 26,
                    ),
                  ),

                  //input field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                      ),
                    ),
                  ),

                  //pick image from gallery
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      size: 26,
                    ),
                  ),

                  //pick image from camera
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //send button
          MaterialButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  APIs.sendMessage(widget.user, _textController.text);
                  _textController.text = '';
                }
              },
              shape: const CircleBorder(),
              // height: size.heig0ht,
              minWidth: 50,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 5, left: 10),
              color: Colors.white70,
              child: const Icon(
                Icons.send,
                size: 28,
              )),
        ],
      ),
    );
  }
}
