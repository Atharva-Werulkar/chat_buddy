import 'package:chat_buddy/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //For Authontication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //For Accessing Cloud firestore databasde
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //to return current user

  static User get user => auth.currentUser!;

  //for checking if user exits or not ?

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
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
}
