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
    apiKey: 'AIzaSyCpjEHssWUswaOmoRfAxOOoV3lUPcmynWg',
    appId: '1:134274675411:web:7412b80ad8341cfc849a26',
    messagingSenderId: '134274675411',
    projectId: 'fir-b1d28',
    authDomain: 'fir-b1d28.firebaseapp.com',
    storageBucket: 'fir-b1d28.appspot.com',
    measurementId: 'G-QYBZK515D3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCSVxnz2m6gpVuUww7_x9p3Mgrpi4cD6M',
    appId: '1:134274675411:android:b3e2bf1a673a5ab3849a26',
    messagingSenderId: '134274675411',
    projectId: 'fir-b1d28',
    storageBucket: 'fir-b1d28.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6kXhueGlNU-1f5yVQzZjGppKzv8xk0UY',
    appId: '1:134274675411:ios:fe2654d731772547849a26',
    messagingSenderId: '134274675411',
    projectId: 'fir-b1d28',
    storageBucket: 'fir-b1d28.appspot.com',
    iosBundleId: 'com.example.movieApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6kXhueGlNU-1f5yVQzZjGppKzv8xk0UY',
    appId: '1:134274675411:ios:d5e0a9217b82e369849a26',
    messagingSenderId: '134274675411',
    projectId: 'fir-b1d28',
    storageBucket: 'fir-b1d28.appspot.com',
    iosBundleId: 'com.example.movieApplication.RunnerTests',
  );
}
