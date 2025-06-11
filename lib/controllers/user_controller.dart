import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appuser.dart'; // Make sure your user model file is named 'user.dart'
import '../services/auth_service.dart';

// **THE FIX**: An enum to represent the different states of the data.
enum UserStatus { loading, loaded, error, unauthenticated }

class UserController extends GetxController {
  static UserController get to => Get.find();

  // **THE FIX**: We now have two variables. One for the loading status,
  // and one for the user data itself.
  final Rx<UserStatus> status = UserStatus.loading.obs;
  final Rxn<AppUser> user = Rxn<AppUser>();

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    // This listener now updates the status correctly.
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        fetchUser(firebaseUser.uid);
      } else {
        user.value = null;
        status.value = UserStatus.unauthenticated;
      }
    });
  }

  Future<void> fetchUser(String uid) async {
    // Tell the UI we are starting to load.
    status.value = UserStatus.loading;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        // SUCCESS: We found the user. Update the data and set status to 'loaded'.
        user.value = AppUser.fromMap(doc.data()!, doc.id);
        status.value = UserStatus.loaded;
      } else {
        // FAILURE: The document was not found. Set status to 'error'.
        print("Error: User document not found for UID: $uid");
        status.value = UserStatus.error;
      }
    } catch (e) {
      // FAILURE: A Firebase error occurred. Set status to 'error'.
      print("Error fetching user data: $e");
      status.value = UserStatus.error;
    }
  }

  Future<bool> updateUserProfile({
    required String name,
    required String imageUrl,
  }) async {
    if (user.value == null) return false;
    try {
      await _authService.updateUserProfile(uid: user.value!.id, name: name, imageUrl: imageUrl);
      // Update the local user data instantly for a great UX.
      user.value = user.value!.copyWith(name: name, profileImageUrl: imageUrl);
      Get.snackbar('Success', 'Profile updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile. Please try again.', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }
}
