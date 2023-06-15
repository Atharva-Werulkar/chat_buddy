import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App BAR
      appBar: AppBar(
        title: const Text("Chat Buddy"),
      ),

      //Add Friend Buttom
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_reaction),
        ),
      ),

      // User Cards
      //
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * .05,
          ),
          child: Column(
            children: [
              //For adding Some Space
              SizedBox(
                width: size.width,
                height: size.height * .05,
              ),
              //user Profile Picture
              ClipRRect(
                borderRadius: BorderRadius.circular(size.height * .1),
                child: CachedNetworkImage(
                  width: size.height * .2,
                  height: size.height * .2,
                  fit: BoxFit.fill,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),

              //For adding Some Space
              SizedBox(
                width: size.width,
                height: size.height * .02,
              ),
              Text(
                widget.user.email,
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              //For adding Some Space
              SizedBox(
                width: size.width,
                height: size.height * .05,
              ),

              //Input Name Field
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: 'Enter Your Name',
                    label: const Text('Name')),
              ),

              //For adding Some Space
              SizedBox(
                width: size.width,
                height: size.height * .03,
              ),

              //Input About Field
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: 'Enter Something About You',
                    label: const Text('About')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
