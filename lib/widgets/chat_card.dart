import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final ChatUser user;

  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * .02, vertical: 5),
      elevation: 0.1,
      child: InkWell(
        onTap: () {},
        child: ListTile(
          //user Profile

          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),

          //User Name

          title: Text(widget.user.name),

          //last Message

          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          //Last Message time

          trailing: const Text(
            "12:00 PM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
