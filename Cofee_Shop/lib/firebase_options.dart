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
    apiKey: 'AIzaSyD-v8M3-HzAjzc_Lyoq0Awp24gZwcPnOaY',
    appId: '1:714985246068:web:270a4f2c7af94c13067021',
    messagingSenderId: '714985246068',
    projectId: 'cofee-shop-a9207',
    authDomain: 'cofee-shop-a9207.firebaseapp.com',
    storageBucket: 'cofee-shop-a9207.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2roMSW-JaU0Mwzyr4XyOlG2IB6AXGZjI',
    appId: '1:714985246068:android:ae854fb5680f84f2067021',
    messagingSenderId: '714985246068',
    projectId: 'cofee-shop-a9207',
    storageBucket: 'cofee-shop-a9207.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlRYngmcDu1yEXilh2hN29vLW2Rt5l4qg',
    appId: '1:714985246068:ios:ff780b8b58e5bf93067021',
    messagingSenderId: '714985246068',
    projectId: 'cofee-shop-a9207',
    storageBucket: 'cofee-shop-a9207.firebasestorage.app',
    iosBundleId: 'com.example.cofeeShop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlRYngmcDu1yEXilh2hN29vLW2Rt5l4qg',
    appId: '1:714985246068:ios:e2d679e4e6c530b6067021',
    messagingSenderId: '714985246068',
    projectId: 'cofee-shop-a9207',
    storageBucket: 'cofee-shop-a9207.firebasestorage.app',
    iosBundleId: 'com.syedh.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD-v8M3-HzAjzc_Lyoq0Awp24gZwcPnOaY',
    appId: '1:714985246068:web:aac51973a113e7d1067021',
    messagingSenderId: '714985246068',
    projectId: 'cofee-shop-a9207',
    authDomain: 'cofee-shop-a9207.firebaseapp.com',
    storageBucket: 'cofee-shop-a9207.firebasestorage.app',
  );
}
