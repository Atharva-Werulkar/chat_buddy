// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/components/date_util.dart';
import 'package:chat_buddy/components/dialogs.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? Widget_SendMessage() : Widget_recivedMessage(),
    );
  }

//Sended Message or Message From Me

  Widget_SendMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Message Content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? size.width * .02
                : size.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: size.width * .04, vertical: size.width * .01),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey.shade300),
              //making border curved
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ?
                //showing text message
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  )
                :
                //showing image message
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image),
                    ),
                  ),
          ),
        ),

        //message  time
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: size.width * .01),
              child: Text(
                MyDateUtil.getFomattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all,
                color: Colors.blue,
                size: 20,
              ),
            SizedBox(width: size.width * .04)
          ],
        ), //blue tick
      ],
    );
  }

//Recived Message Or Meassage From Other User

  Widget_recivedMessage() {
    //update last read message if sender and reciver is defferent
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //for some space
            SizedBox(width: size.width * .04),

            // //blue tick
            // if (widget.message.read.isNotEmpty)
            //   const Icon(
            //     Icons.done_all,
            //     color: Colors.blue,
            //     size: 20,
            //   ),

            // //for some space

            const SizedBox(width: 2),

            //read time
            Text(
              MyDateUtil.getFomattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? size.width * .02
                : size.width * .04),
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
            child: widget.message.type == Type.text
                ?
                //showing text message
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  )
                :
                //showing image message
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

// Bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black line/divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: size.height * .015, horizontal: size.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ? //Copy Option
                  _OptionItem(
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 26,
                      ),
                      name: 'Copy Text',
                      //copy text to clipboard
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //close bottom sheet
                          Navigator.pop(context);
                          Dialogs.showSnakbar(context, "Text Copied");
                        });
                      })
                  :

                  //Save Image Option
                  _OptionItem(
                      icon: const Icon(
                        Icons.download_rounded,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'Chat Buddy')
                              .then((success) {
                            //close bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnakbar(context, "Image Saved");
                            } else {
                              Dialogs.showSnakbar(context, "Image Not Saved");
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImage $e');
                        }
                      }),

              //Divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: size.width * .04,
                  indent: size.width * .04,
                ),

              //edit Option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 26,
                    ),
                    name: 'Edit Message',
                    onTap: () {}),

              //Delet Option
              if (isMe)
                _OptionItem(
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      size: 26,
                    ),
                    name: 'Delet Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //close bottom sheet
                        Navigator.pop(context);
                        Dialogs.showSnakbar(context, "Message Deleted");
                      });
                    }),

              //Divider
              Divider(
                color: Colors.black54,
                endIndent: size.width * .04,
                indent: size.width * .04,
              ),

              //Sent time
              _OptionItem(
                  icon: const Icon(
                    Icons.send_rounded,
                  ),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //Read time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                  ),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not Read Yet'
                      : 'Read At ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }
}

//Option Item for bottom sheet
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: size.width * .05,
            top: size.height * .015,
            bottom: size.height * .02),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: size.width * .03,
            ),
            Flexible(child: Text(name))
          ],
        ),
      ),
    );
  }
}
