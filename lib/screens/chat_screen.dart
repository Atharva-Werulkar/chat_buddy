import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      )),
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
}
