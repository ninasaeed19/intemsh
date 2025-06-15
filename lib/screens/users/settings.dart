import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart'; // Import the new controller

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of the ThemeController.
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Use Obx to make the switch react to theme changes.
          Obx(() {
            return SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable a dark theme for the app'),
              // The switch's value is now controlled by the controller.
              value: themeController.isDarkMode,
              // When the switch is tapped, call the controller's toggle method.
              onChanged: (bool value) {
                themeController.toggleTheme();
              },
              secondary: const Icon(Icons.dark_mode_outlined),
              activeColor: Theme.of(context).primaryColor,
            );
          }),
          const Divider(),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive alerts for new events'),
            value: true, // This remains a UI-only switch for now
            onChanged: (bool value) {},
            secondary: const Icon(Icons.notifications_active_outlined),
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
