// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDUfx84YnGvdPF3ze4Zsgay2S1pP3CkiBE',
    appId: '1:860361336756:web:4bb9a22de5fa48fd15f4e1',
    messagingSenderId: '860361336756',
    projectId: 'chat-buddy-460bc',
    authDomain: 'chat-buddy-460bc.firebaseapp.com',
    storageBucket: 'chat-buddy-460bc.appspot.com',
    measurementId: 'G-7ZVHNQ3K32',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjVN3UpmiW8iwgYPaquP654XPpKL9MOCU',
    appId: '1:860361336756:android:bef3149cf64865a115f4e1',
    messagingSenderId: '860361336756',
    projectId: 'chat-buddy-460bc',
    storageBucket: 'chat-buddy-460bc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDrjFmkczkUrcvUoUwsm9gzdp5W1nitPk',
    appId: '1:860361336756:ios:3435421729f3553215f4e1',
    messagingSenderId: '860361336756',
    projectId: 'chat-buddy-460bc',
    storageBucket: 'chat-buddy-460bc.appspot.com',
    androidClientId: '860361336756-qqmcmmp50n8a35n7slcov5crjrfgdr9b.apps.googleusercontent.com',
    iosClientId: '860361336756-ajfkahd39vm9q4l073tk0709j2j3em8h.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatBuddy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDrjFmkczkUrcvUoUwsm9gzdp5W1nitPk',
    appId: '1:860361336756:ios:6b909134d074e39415f4e1',
    messagingSenderId: '860361336756',
    projectId: 'chat-buddy-460bc',
    storageBucket: 'chat-buddy-460bc.appspot.com',
    androidClientId: '860361336756-qqmcmmp50n8a35n7slcov5crjrfgdr9b.apps.googleusercontent.com',
    iosClientId: '860361336756-u39un8bua9bm6rvkd7f3a94js09pu9p7.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatBuddy.RunnerTests',
  );
}
