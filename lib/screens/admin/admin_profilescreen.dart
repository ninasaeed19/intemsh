import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../services/auth_service.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
      ),

      body: Obx(() {
        if (userController.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final admin = userController.user.value!;

        final placeholderImage = 'https://placehold.co/100x100/E91E63/FFFFFF?text=${admin.name.substring(0, 1).toUpperCase()}';

        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(admin.profileImageUrl ?? placeholderImage),
                    ),
                    const SizedBox(height: 12),
                    Text(admin.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(admin.email, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                    const SizedBox(height: 8),
                    Chip(
                      label: const Text('Administrator'),
                      backgroundColor: Theme.of(context).primaryColor,
                      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Menu Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit_outlined, color: Theme.of(context).primaryColor),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {

                          Get.toNamed('/edit_profile');
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
                        title: const Text('Settings'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {

                          Get.toNamed('/settings');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Logout Button
              _buildLogoutButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton.icon(
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.red),
          ),
        ),
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
                TextButton(
                  child: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Get.find<AuthService>().logout();
                    Get.offAllNamed('/login');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
