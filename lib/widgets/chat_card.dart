import 'package:chat_buddy/main.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({super.key});

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
        child: const ListTile(
          //user Profile

          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),

          //User Name

          title: Text("Demo User"),

          //last Message

          subtitle: Text("Last sended Message"),

          //Last Message time

          trailing: Text(
            "12:00 PM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
