// In lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // You can add web options here later if you need them
      throw UnsupportedError('Web is not configured for this project.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        // You can add iOS options here later
        throw UnsupportedError('iOS is not configured for this project.');
      // ... handle other platforms or throw error
      default:
        throw UnsupportedError('This platform is not supported.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAfoeCtJpy-l__vWU0SOqsmXzrG7pDqCcU",
    appId:
        "1:569367084750:android:de29abd779ec78d60e5a9f", // screenshot එකේ තියෙන App ID එක දාන්න
    messagingSenderId:
        "569367084750", // Cloud Messaging වලින් ගත්ත Sender ID එක දාන්න
    projectId: "smart-evcharger", // ඔයාගේ Project ID එක දාන්න
    storageBucket: "smart-evcharger.appspot.com", // Project ID එක දාලා හදන්න
  );
}
