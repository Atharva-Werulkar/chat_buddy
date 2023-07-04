import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_buddy/models/chat_user.dart';
import 'package:chat_buddy/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

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

  //For Accessing Firebase Messaging
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  //----- APIs Functions -----//

  //for getting push token
  static Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();

    await fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('push_token $t');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  //for sending push notification
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": {
          "some_data": "User ID: ${me.id}}",
        },
      };
      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAyFGIJ7Q:APA91bFbBGBJF2sfgtRzDIh8V9TOh7T-fHZQIkoiTDmYrRMvbk3JxDiamDV758djrns_fYBtPtor48JWFXicGp8Ocx1xx1JiPRxnZr_hoByofTntkKZRyunccGUaaR519Z7SE61-yH2R',
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationError: $e');
    }
  }

  //for checking if user exits or not ?

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for adding new user to firestore database

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    log('Data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exist: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user not exists
      return false;
    }
  }

  //for deleting chat user form firestore
  static void deleteChatAction(ChatUser currentUserId, ChatUser deletId) {
    firestore
        .collection('users')
        .doc(currentUserId.id)
        .collection('my_users')
        .doc(deletId.id)
        .delete()
        .then((_) {
      // Chat successfully deleted
      log('Chat deleted with user: $deletId');
    }).catchError((error) {
      // An error occurred while deleting the chat
      log('Failed to delete chat: $error');
    });
  }

  //for showing logined user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        APIs.updateActiveStatus(true);

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

  //for getting id's of known users

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  //for getting all Users

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> ids) {
    log('Ids: $ids');

    return firestore
        .collection('users')
        .where('id',
            whereIn:
                ids.isEmpty ? [''] : ids) //because empty list throws an error
        // .where('id', whereIn: ids)
        .snapshots();
  }

  //for adding an user to my user when first message is sent

  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
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

  //for getting specific users info

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  //updating online or last active status of user

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  //<-----Chat Screen Related APIs----->//

  //for getting converstion id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting all messages of a specific conversations from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for sending message

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as message id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send

    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: '',
        type: type,
        sent: time,
        fromId: user.uid);

    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'Image'));
  }

  //update read status of message

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //for sending image

  static Future<void> sendImage(ChatUser chatUser, File file) async {
    //getting extension of file
    final ext = file.path.split('.').last;

    //store file with extension
    final ref = storage.ref().child(
        'images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading file to firebase storage
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((val) {
      log('Data Transfered: ${val.bytesTransferred / 1000}kb');
    });

    //updating user profile picture
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //for deleting message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    //delete image from firebase storage

    if (message.type == Type.image) {
      final ref = storage.refFromURL(message.msg);
      await ref.delete();
    }
  }

  //for editing message
  static Future<void> editMessage(Message message, String editedMessage) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': editedMessage});
  }
}
