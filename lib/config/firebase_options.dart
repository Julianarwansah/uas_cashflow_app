import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0kSCbFNwG9IHQV78aWLfre7xdTloFHi0',
    appId: '1:712776728248:web:YOUR_WEB_APP_ID',
    messagingSenderId: '712776728248',
    projectId: 'uas-cashflow-app',
    authDomain: 'uas-cashflow-app.firebaseapp.com',
    storageBucket: 'uas-cashflow-app.firebasestorage.app',
  );
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0kSCbFNwG9IHQV78aWLfre7xdTloFHi0',
    appId: '1:712776728248:android:afb109c145ae3612607e4d',
    messagingSenderId: '712776728248',
    projectId: 'uas-cashflow-app',
    storageBucket: 'uas-cashflow-app.firebasestorage.app',
  );
}
