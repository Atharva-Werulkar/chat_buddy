// ignore_for_file: non_constant_identifier_names

import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? Widget_SendMessage()
        : Widget_recivedMessage();
  }

//Sended Message

  Widget_SendMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
              padding: EdgeInsets.all(size.width * .04),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * .04, vertical: size.width * .01),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(right: size.width * .04),
          child: Text(
            widget.message.sent,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }

//Recived Message
  Widget_recivedMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //blue tick

        //read time

        Row(
          children: [
            //for some space
            SizedBox(width: size.width * .04),

            //blue tick
            const Icon(
              Icons.done_all,
              color: Colors.blue,
              size: 20,
            ),

            //for some space

            const SizedBox(width: 2),

            //read time
            Text(
              '${widget.message.read}12:00AM',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
              padding: EdgeInsets.all(size.width * .04),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * .04, vertical: size.width * .01),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Text(
                widget.message.msg,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              )),
        ),
      ],
    );
  }
}
