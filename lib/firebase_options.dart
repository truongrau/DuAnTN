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
    apiKey: 'AIzaSyBM8woCtycdBxjLsha6sDdtyh03bigJzMs',
    appId: '1:204912491565:web:43f0347c5bc699e331cca4',
    messagingSenderId: '204912491565',
    projectId: 'managercoffeeandfood',
    authDomain: 'managercoffeeandfood.firebaseapp.com',
    storageBucket: 'managercoffeeandfood.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9cC2pN_KfgROBsiN8fezAHYVCQjd0C-4',
    appId: '1:204912491565:android:ed1e934fe3c1356531cca4',
    messagingSenderId: '204912491565',
    projectId: 'managercoffeeandfood',
    storageBucket: 'managercoffeeandfood.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjypEg_M9VpQauFD3ZqsPQ-1lTs7vK2b4',
    appId: '1:204912491565:ios:fef0c8e72e56e4ee31cca4',
    messagingSenderId: '204912491565',
    projectId: 'managercoffeeandfood',
    storageBucket: 'managercoffeeandfood.appspot.com',
    iosClientId: '204912491565-3331nbjijmtv6me3vsun87v7hv2gt33e.apps.googleusercontent.com',
    iosBundleId: 'com.example.managerfoodandcoffee',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjypEg_M9VpQauFD3ZqsPQ-1lTs7vK2b4',
    appId: '1:204912491565:ios:ec6e5601a0c68b5031cca4',
    messagingSenderId: '204912491565',
    projectId: 'managercoffeeandfood',
    storageBucket: 'managercoffeeandfood.appspot.com',
    iosClientId: '204912491565-medk8ta8cki73hfp66341gs098bdfd5b.apps.googleusercontent.com',
    iosBundleId: 'com.example.managerfoodandcoffee.RunnerTests',
  );
}
