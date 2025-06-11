import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class RoleController extends GetxController {
  static RoleController get to => Get.find();

  final AuthService _authService = Get.find<AuthService>();
  final RxString userRole = ''.obs;

  /// Checks the user's role from Firestore and navigates to the correct screen.
  Future<void> checkRoleAndNavigate() async {
    // Show a temporary loading dialog for better UX
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final String? role = await _authService.getUserRole();

      // IMPORTANT: Add this print statement for debugging.
      // Check your "Debug Console" after logging in to see what it prints.
      print("--- ROLE CHECK --- Fetched role from Firestore: '$role' ---");

      // Dismiss the loading dialog
      Get.back();

      if (role == 'admin') {
        userRole.value = 'admin';
        // Navigate to admin dashboard, clearing all previous routes
        Get.offAllNamed('/admin/dashboard');
      } else {
        // For any other case ('user', null, or a random value),
        // default to the user home screen for security.
        userRole.value = 'user';
        Get.offAllNamed('/home');
      }
    } catch (e) {
      // If there's an error, dismiss the dialog and go to the home screen
      Get.back();
      print("Error during role check: $e");
      Get.offAllNamed('/home');
      Get.snackbar(
        'Error',
        'Could not verify user role. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool get isAdmin => userRole.value == 'admin';
}
