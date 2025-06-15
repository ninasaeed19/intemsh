import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // A reactive variable to hold the current theme mode.
  // We initialize it with the system's default theme.
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // A simple getter to check if the current mode is dark.
  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  /// Switches the theme between light and dark mode.
  void toggleTheme() {
    // If the current theme is dark, switch to light, and vice versa.
    themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    // Update the theme using GetX's built-in theme manager.
    Get.changeThemeMode(themeMode.value);
  }
}
