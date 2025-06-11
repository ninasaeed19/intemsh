import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        appId: "YOUR_APP_ID",
        messagingSenderId: "YOUR_SENDER_ID",
        projectId: "YOUR_PROJECT_ID",
        // Only needed for web:
        authDomain: "YOUR_AUTH_DOMAIN",
        storageBucket: "YOUR_STORAGE_BUCKET",
      ),
    );
  }

  // Get Firestore instance
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Get Auth instance
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // Get Storage instance
  static FirebaseStorage get storage => FirebaseStorage.instance;
}