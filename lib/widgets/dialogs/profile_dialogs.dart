import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/view_profile_picture.dart';
import 'package:chat_buddy/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: size.width * .6,
        height: size.height * .35,
        child: Stack(
          children: [
            //profile image
            Positioned(
              top: size.height * .075,
              left: size.width * .05,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ShowProfile(imageUrl: user.image)),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.height * .3),
                  child: CachedNetworkImage(
                    width: size.width * .5,
                    height: size.width * .5,
                    fit: BoxFit.contain,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),

            //name
            Positioned(
              left: size.width * .04,
              top: size.height * .02,
              width: size.width * .55,
              child: Text(user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
            ),

            //info icon
            Positioned(
                right: size.width * .001,
                top: size.height * .01,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  icon: const Icon(Icons.info_outline, size: 30),
                )),
          ],
        ),
      ),
    );
  }
}
