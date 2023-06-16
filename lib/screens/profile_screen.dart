import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/components/dialogs.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //App BAR
        appBar: AppBar(
          title: const Text("Chat Buddy"),
        ),

        //Add Friend Buttom
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);

              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                });
              });
            },
            label: const Text("Logout"),
            icon: const Icon(Icons.logout),
          ),
        ),

        // User Cards
        //
        body: Form(
          key: _formkey,
          child: Padding(
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

                  Stack(
                    children: [
                      //user Profile Picture
                      ClipRRect(
                        borderRadius: BorderRadius.circular(size.height * .1),
                        child: CachedNetworkImage(
                          width: size.height * .2,
                          height: size.height * .2,
                          fit: BoxFit.fill,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),

                      //edit profile button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          height: 50,
                          onPressed: () {},
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.edit),
                        ),
                      )
                    ],
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
                    height: size.height * .05,
                  ),

                  //Input Name Field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
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
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Enter Something About You',
                        label: const Text('About')),
                  ),

                  //For adding Some Space
                  SizedBox(
                    height: size.height * .05,
                  ),

                  //update profile button
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize:
                              Size(size.width * .5, size.height * .06)),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnakbar(
                                context, 'Profile Updated Successfully');
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      label: const Text(
                        'UPDATE',
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
