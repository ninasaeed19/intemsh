import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/appuser.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  // --- MOCK DATA: A local list to represent the users in the database ---
  final List<AppUser> _mockUsers = [
    AppUser(
      id: 'admin123',
      name: 'Hana Admin',
      email: 'hana.admin@university.edu.eg',
      role: 'admin',
      profileImageUrl: 'https://i.pravatar.cc/150?u=hana',
    ),
    AppUser(
      id: 'user456',
      name: 'Shaza User',
      email: 'shaza.user@university.edu.eg',
      role: 'user',
      profileImageUrl: 'https://i.pravatar.cc/150?u=shaza',
    ),
    AppUser(
      id: 'user789',
      name: 'Ali Student',
      email: 'ali.student@university.edu.eg',
      role: 'user',
      profileImageUrl: 'https://i.pravatar.cc/150?u=ali',
    ),
    AppUser(
      id: 'user101',
      name: 'Fatima Graduate',
      email: 'fatima.grad@university.edu.eg',
      role: 'user',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      // We use a simple ListView.builder to display our mock list
      body: ListView.builder(
        itemCount: _mockUsers.length,
        itemBuilder: (context, index) {
          final user = _mockUsers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pink.shade100,
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? Text(user.name.isNotEmpty ? user.name.substring(0, 1) : '?')
                    : null,
              ),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(user.email),
              // The trailing widget shows the role and the menu
              trailing: _buildRoleChipAndMenu(context, user),
            ),
          );
        },
      ),
    );
  }

  // A helper widget to display the role chip and the popup menu
  Widget _buildRoleChipAndMenu(BuildContext context, AppUser user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
          label: Text(
            user.role.capitalizeFirst ?? user.role,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          backgroundColor: user.isAdmin ? Theme.of(context).primaryColor : Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            // The action here is just a snackbar for demonstration
            String newRole = value;
            Get.snackbar(
                'Role Change (UI Demo)',
                'Changing ${user.name}\'s role to ${newRole.capitalizeFirst}.',
                snackPosition: SnackPosition.BOTTOM
            );
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            // Only show "Make User" if they are currently an admin
            if (user.isAdmin)
              const PopupMenuItem<String>(
                value: 'user',
                child: Text('Make User'),
              ),
            // Only show "Make Admin" if they are not currently an admin
            if (!user.isAdmin)
              const PopupMenuItem<String>(
                value: 'admin',
                child: Text('Make Admin'),
              ),
          ],
        ),
      ],
    );
  }
}
