import 'package:flutter/material.dart'; // **THE FIX**: Added this import for 'Colors'
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/appuser.dart';
import '/services/auth_service.dart';

enum UserStatus { loading, loaded, error, unauthenticated }

class UserController extends GetxController {
  static UserController get to => Get.find();

  final Rx<UserStatus> status = UserStatus.loading.obs;
  final Rxn<AppUser> user = Rxn<AppUser>(); // This is the reactive variable

  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
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
    status.value = UserStatus.loading;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        user.value = AppUser.fromMap(doc.data()!, doc.id);
        status.value = UserStatus.loaded;
      } else {
        status.value = UserStatus.error;
      }
    } catch (e) {
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
      user.value = user.value!.copyWith(name: name, profileImageUrl: imageUrl);
      Get.snackbar('Success', 'Profile updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile. Please try again.', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }
}
