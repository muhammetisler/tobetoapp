// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC9Ip380eoDP915jpP39S19WwqHs35aRvE',
    appId: '1:161083224279:web:5f5e837ff1998334570092',
    messagingSenderId: '161083224279',
    projectId: 'tobetoapp-3375c',
    authDomain: 'tobetoapp-3375c.firebaseapp.com',
    storageBucket: 'tobetoapp-3375c.appspot.com',
    measurementId: 'G-SHXR4CHYLQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIsXD8y33S1uNSiZNn5LdR16sRl3ORIVw',
    appId: '1:161083224279:android:73cbfebefc393ed4570092',
    messagingSenderId: '161083224279',
    projectId: 'tobetoapp-3375c',
    storageBucket: 'tobetoapp-3375c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZrsUBYlDDMj46ZUr4OhFajvMt9x75wpA',
    appId: '1:161083224279:ios:4f75250c3beb0c41570092',
    messagingSenderId: '161083224279',
    projectId: 'tobetoapp-3375c',
    storageBucket: 'tobetoapp-3375c.appspot.com',
    iosBundleId: 'com.example.tobetoappv1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZrsUBYlDDMj46ZUr4OhFajvMt9x75wpA',
    appId: '1:161083224279:ios:4f75250c3beb0c41570092',
    messagingSenderId: '161083224279',
    projectId: 'tobetoapp-3375c',
    storageBucket: 'tobetoapp-3375c.appspot.com',
    iosBundleId: 'com.example.tobetoappv1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC9Ip380eoDP915jpP39S19WwqHs35aRvE',
    appId: '1:161083224279:web:6722211c7a955da6570092',
    messagingSenderId: '161083224279',
    projectId: 'tobetoapp-3375c',
    authDomain: 'tobetoapp-3375c.firebaseapp.com',
    storageBucket: 'tobetoapp-3375c.appspot.com',
    measurementId: 'G-Z0ZC3NK382',
  );
}
