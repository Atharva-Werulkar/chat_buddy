import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/chat_screen.dart';
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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: ListTile(
            //user Profile

            leading: ClipRRect(
              borderRadius: BorderRadius.circular(size.height * .3),
              child: CachedNetworkImage(
                width: size.height * .055,
                height: size.height * .055,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),

            //User Name

            title: Text(widget.user.name),

            //last Message

            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),

            //Last Message time

            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(10)),
            )

            //  trailing: const Text(
            //   "12:00 PM",
            //   style: TextStyle(color: Colors.black54),
            // ),
            ),
      ),
    );
  }
}
