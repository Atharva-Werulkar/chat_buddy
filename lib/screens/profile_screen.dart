// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_buddy/api/apis.dart';
import 'package:chat_buddy/components/dialogs.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/screens/auth/login_screen.dart';
import 'package:chat_buddy/screens/view_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();

  String? _image;

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

              await APIs.updateActiveStatus(false);

              //signout from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //for hiding progress bar
                  Navigator.pop(context);

                  //for moving to home screen
                  Navigator.pop(context);

                  APIs.auth = FirebaseAuth.instance;

                  //for moving to login screen
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ShowProfile(imageUrl: widget.user.image)),
                          );
                        },
                        child: _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: size.height * .2,
                                  height: size.height * .2,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.height * .1),
                                child: CachedNetworkImage(
                                  width: size.height * .2,
                                  height: size.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              ),
                      ),

                      //edit profile button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          height: 50,
                          onPressed: () {
                            _showBottomSheet();
                          },
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
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          size: 28,
                        ),
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

// Bottom sheet To Pick Profile picture for users
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: size.height * .02, bottom: size.height * .05),
            children: [
              //Drawer Title
              const Text(
                "Pick Profile picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),

              //For adding Some Space
              SizedBox(
                height: size.height * .02,
              ),

              //Drawer Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Gallery Button

                  ElevatedButton.icon(
                      style:
                          ButtonStyle(iconSize: MaterialStateProperty.all(30)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final ImageCropper cropper = ImageCropper();

                        // Pick an image .
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          log('image path: ${image.path} --MimeType: ${image.mimeType}');

                          final CroppedFile? crop = await cropper.cropImage(
                              sourcePath: image.path,
                              aspectRatio:
                                  const CropAspectRatio(ratioX: 1, ratioY: 1),
                              compressQuality: 100,
                              compressFormat: ImageCompressFormat.jpg);
                          if (crop != null) {
                            setState(() {
                              _image = crop.path;
                            });
                            APIs.updateProfilePicture(File(_image!));
                          }

                          //for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.photo),
                      label: const Text('Gallery')),

                  //Camera Button
                  ElevatedButton.icon(
                      style:
                          ButtonStyle(iconSize: MaterialStateProperty.all(30)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image .
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log('image path: ${image.path}');

                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          //for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Camera'))
                ],
              ),
            ],
          );
        });
  }
}
