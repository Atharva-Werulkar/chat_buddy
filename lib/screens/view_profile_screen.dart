import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/components/date_util.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/view_profile_picture.dart';
import 'package:flutter/material.dart';

//view profile screen
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //App BAR
        appBar: AppBar(
          title: Text(widget.user.name),
        ),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(
              MyDateUtil.getLastMessageTime(
                  context: context, time: widget.user.createdAt),
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),

        //body
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //For adding Some Space
                SizedBox(
                  width: size.width,
                  height: size.height * .05,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ShowProfile(imageUrl: widget.user.image)),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.height * .1),
                    child: CachedNetworkImage(
                      width: size.height * .2,
                      height: size.height * .2,
                      fit: BoxFit.contain,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),

                //For adding Some Space
                SizedBox(
                  width: size.width,
                  height: size.height * .02,
                ),

                //user email lable
                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.black87, fontSize: 18),
                ),
                //For adding Some Space
                SizedBox(
                  width: size.width,
                  height: size.height * .02,
                ),
                //user about lable
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(
                      widget.user.about,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
