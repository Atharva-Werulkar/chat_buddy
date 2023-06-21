import 'dart:developer';
import 'dart:io';

import 'package:chat_buddy/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  //For Authontication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //For Accessing Cloud firestore databasde
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //For Accessing Firebase Storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUser me;

  //to return current user

  static User get user => auth.currentUser!;

  //for checking if user exits or not ?

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for showing logined user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data:${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //for creating new user

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey, I'm using ChatBuddy",
        name: user.displayName.toString(),
        createdAt: time,
        id: user.uid,
        lastActive: time,
        isOnline: false,
        email: user.email.toString(),
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

//for getting all Users

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for updating user

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

//for updating user profile picture
  static Future<void> updateProfilePicture(File file) async {
    //getting extension of file
    final ext = file.path.split('.').last;
    log("Extension: $ext");

    //store file with extension
    final ref = storage.ref().child('profile_picture/${user.uid}.$ext');

//uploading file to firebase storage
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((val) {
      log('Data Transfered: ${val.bytesTransferred / 1000}kb');
    });

//updating user profile picture
    me.image = await ref.getDownloadURL();

    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

//-----Chat Screen Related APIs-----//

//for getting all messages of a specific conversations from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore.collection('messages').snapshots();
  }
}
