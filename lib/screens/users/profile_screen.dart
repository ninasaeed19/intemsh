import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../controllers/user_controller.dart';

// **THE FIX**: This file now ONLY contains the ProfileScreen widget.
// The UserController class definition has been removed to solve the import error.

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Obx(() {
        switch (userController.status.value) {
          case UserStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case UserStatus.error:
            return const Center(child: Text('Could not load profile.', style: TextStyle(color: Colors.red)));
          case UserStatus.unauthenticated:
            return const Center(child: Text('Please log in.'));
          case UserStatus.loaded:
          // **THE FIX**: Access the user object with .value
            final user = userController.user.value!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context, user.name, user.email, user.profileImageUrl),
                  const SizedBox(height: 20),
                  _buildMenuOptions(context),
                  const SizedBox(height: 30),
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            );
        }
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String email, String? imageUrl) {
    final placeholderImage = 'https://placehold.co/100x100/FCE4EC/E91E63?text=${name.isNotEmpty ? name.substring(0, 1) : "U"}';
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(imageUrl != null && imageUrl.isNotEmpty ? imageUrl : placeholderImage),
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(email, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            _buildMenuTile(title: 'My Bookings', icon: Icons.event_note_outlined, onTap: () => Get.toNamed('/my_bookings')),
            const Divider(height: 1),
            _buildMenuTile(title: 'Edit Profile', icon: Icons.edit_outlined, onTap: () => Get.toNamed('/edit_profile')),
            const Divider(height: 1),
            _buildMenuTile(title: 'Settings', icon: Icons.settings_outlined, onTap: () => Get.toNamed('/settings')),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink.shade700),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.red)),
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
