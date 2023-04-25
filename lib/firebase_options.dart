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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyATewjrf0hXBASZ63XQ6mVn474kXE6brBY',
    appId: '1:786574581911:web:925b28d615e40e021fc9d2',
    messagingSenderId: '786574581911',
    projectId: 'oobacht-ea4d4',
    authDomain: 'oobacht-ea4d4.firebaseapp.com',
    storageBucket: 'oobacht-ea4d4.appspot.com',
    measurementId: 'G-1LKQ517YJH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQKNL739TMQCuh5tIboB9oLIA_F2KPsvI',
    appId: '1:786574581911:android:69aa29d3a036371b1fc9d2',
    messagingSenderId: '786574581911',
    projectId: 'oobacht-ea4d4',
    storageBucket: 'oobacht-ea4d4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAARlyxvBFQL8VyCwgOe3HfCKDpF7yewWw',
    appId: '1:786574581911:ios:903f0bf6f929ea641fc9d2',
    messagingSenderId: '786574581911',
    projectId: 'oobacht-ea4d4',
    storageBucket: 'oobacht-ea4d4.appspot.com',
    androidClientId: '786574581911-7p6kko1ssla9bpber787ech22h9eilve.apps.googleusercontent.com',
    iosClientId: '786574581911-308lt9s32btheh1i2fkr7knnv45182jn.apps.googleusercontent.com',
    iosBundleId: 'de.dhbw.oobacht',
  );
}
