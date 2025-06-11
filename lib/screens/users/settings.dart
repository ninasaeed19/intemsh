import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive alerts for new events and updates'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications_active_outlined),
            activeColor: Theme.of(context).primaryColor,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable a dark theme for the app'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
                // In a real app, you would use Get.changeTheme() or similar
              });
            },
            secondary: const Icon(Icons.dark_mode_outlined),
            activeColor: Theme.of(context).primaryColor,
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.privacy_tip_outlined),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Action for privacy policy
            },
          ),
          ListTile(
            title: const Text('About Us'),
            leading: const Icon(Icons.info_outline),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Action for about us
            },
          ),
        ],
      ),
    );
  }
}
