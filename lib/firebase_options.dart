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
    apiKey: 'AIzaSyBoKUpwSorsHZ9QzVlG-OpNRkTLCCZ-nIA',
    appId: '1:938145287148:web:e5cca3387445ef66c68ec9',
    messagingSenderId: '938145287148',
    projectId: 'now-u-d140a',
    authDomain: 'now-u-d140a.firebaseapp.com',
    databaseURL: 'https://now-u-d140a.firebaseio.com',
    storageBucket: 'now-u-d140a.appspot.com',
    measurementId: 'G-3P1J1GVPTY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLNGjYAvcbEOR8SH0pMPmbrZTRRitFJUA',
    appId: '1:938145287148:android:4dc007286ce4ae2ac68ec9',
    messagingSenderId: '938145287148',
    projectId: 'now-u-d140a',
    databaseURL: 'https://now-u-d140a.firebaseio.com',
    storageBucket: 'now-u-d140a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCra_DdnjjKhFrbMadUtnKPKbRYd0qEotY',
    appId: '1:938145287148:ios:1527edd0f9d24278c68ec9',
    messagingSenderId: '938145287148',
    projectId: 'now-u-d140a',
    databaseURL: 'https://now-u-d140a.firebaseio.com',
    storageBucket: 'now-u-d140a.appspot.com',
    iosClientId:
        '938145287148-3b96qect9a9drnhsio206ld9go22fk1h.apps.googleusercontent.com',
    iosBundleId: 'com.nowu.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCra_DdnjjKhFrbMadUtnKPKbRYd0qEotY',
    appId: '1:938145287148:ios:1527edd0f9d24278c68ec9',
    messagingSenderId: '938145287148',
    projectId: 'now-u-d140a',
    databaseURL: 'https://now-u-d140a.firebaseio.com',
    storageBucket: 'now-u-d140a.appspot.com',
    iosClientId:
        '938145287148-3b96qect9a9drnhsio206ld9go22fk1h.apps.googleusercontent.com',
    iosBundleId: 'com.nowu.app',
  );
}
