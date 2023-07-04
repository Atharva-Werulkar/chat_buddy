import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/components/date_util.dart';
import 'package:chat_buddy/components/dialogs.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/models/message.dart';
import 'package:chat_buddy/screens/chat_screen.dart';
import 'package:chat_buddy/widgets/dialogs/profile_dialogs.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final ChatUser user;

  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
//last message info (if null then no message is sent)
  Message? _lastmessage;

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
        onLongPress: () {
          _deleteChatAction(context);
        },
        child: StreamBuilder(
          stream: APIs.getAllMessages(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) {
              _lastmessage = list[0];
            }

            return ListTile(
              //user Profile

              leading: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => ProfileDialog(user: widget.user));
                },
                child: ClipRRect(
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
              ),

              //User Name

              title: Text(widget.user.name),

              //last Message

              subtitle: Text(
                _lastmessage != null
                    ? _lastmessage!.type == Type.image
                        ? 'image'
                        : _lastmessage!.msg
                    : widget.user.about,
                maxLines: 1,
              ),

              //Last Message time

              trailing: _lastmessage == null
                  ? null //if no message is sent then no time will be shown
                  : _lastmessage!.read.isEmpty &&
                          _lastmessage!.fromId != APIs.user.uid
                      ?
                      //if message is not read and message is not sent by me then show green dot
                      Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      //if message is read or message is sent by me then show time
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: _lastmessage!.sent),
                          style: const TextStyle(color: Colors.black54),
                        ),
            );
          },
        ),
      ),
    );
  }

  void _deleteChatAction(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () {
              // Close dialog
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform the deletion

              APIs.deleteChatAction(APIs.me, widget.user);

              // Close dialog
              Navigator.pop(context);
              // Show snackbar or any other feedback
              Dialogs.showSnakbar(context, 'Chat Deleted');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
