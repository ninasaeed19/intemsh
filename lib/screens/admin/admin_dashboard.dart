import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/event_controller.dart';
import '../../services/auth_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final EventController eventController = Get.find<EventController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Admin Profile',
            onPressed: () {
              Get.toNamed('/admin/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
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
          )
        ],
      ),
      // THE FIX: We now use Obx to reactively check the loading status.
      body: Obx(() {
        // If either the user data or the event data is still loading, show a spinner.
        if (userController.status.value == UserStatus.loading || eventController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // If there was an error loading the user, show an error message.
        if (userController.status.value == UserStatus.error) {
          return const Center(child: Text('Could not load admin data.', style: TextStyle(color: Colors.red)));
        }

        // Once everything is loaded, build the main dashboard UI.
        final adminName = userController.user.value?.name ?? 'Admin';
        final upcomingCount = eventController.upcomingEvents.length;
        final pendingCount = eventController.pendingEvents.length;
        const totalUsers = 256;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, $adminName!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Here is a summary of your app\'s activity.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildStatsRow(upcomingCount, totalUsers, pendingCount),
              const SizedBox(height: 24),
              _buildQuickActions(context, pendingCount),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsRow(int upcomingCount, int totalUsers, int pendingCount) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.event_available,
                label: 'Upcoming',
                value: upcomingCount.toString(),
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.people,
                label: 'Total Users',
                value: totalUsers.toString(),
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.pending_actions,
                label: 'Pending',
                value: pendingCount.toString(),
                color: Colors.orange.shade800,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, int pendingCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Column(
            children: [
              _ActionTile(
                icon: Icons.edit_calendar,
                title: 'Manage Events',
                subtitle: 'Create, edit, and approve events',
                onTap: () => Get.toNamed('/admin/manage_events'),
              ),
              const Divider(height: 1),
              _ActionTile(
                icon: Icons.group,
                title: 'Manage Users',
                subtitle: 'View and manage user roles',
                onTap: () => Get.toNamed('/admin/manage_users'),
              ),
              if (pendingCount > 0) ...[
                const Divider(height: 1),
                _ActionTile(
                  icon: Icons.notification_important_rounded,
                  title: 'Pending Approvals',
                  subtitle: '$pendingCount event(s) awaiting review',
                  onTap: () {
                    Get.toNamed('/admin/manage_events');
                  },
                  trailing: const Icon(Icons.circle, color: Colors.orange, size: 12),
                ),
              ],
            ],
          ),
        )
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        foregroundColor: Theme.of(context).primaryColor,
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
