import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/appuser.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        final newUser = AppUser(id: userCredential.user!.uid, name: name, email: email);
        await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());
        await userCredential.user!.updateDisplayName(name);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// **FIXED**: Added the missing 'login' method.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// **FIXED**: Added the missing 'getUserRole' method.
  Future<String?> getUserRole() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;
    try {
      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!['role'] as String?;
      }
      return 'user';
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    required String imageUrl,
  }) async {
    await _firestore.collection('users').doc(uid).update({'name': name, 'profileImageUrl': imageUrl});
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(name);
      await _auth.currentUser!.updatePhotoURL(imageUrl);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
