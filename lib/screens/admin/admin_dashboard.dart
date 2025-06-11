import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/user_controller.dart'; // Import UserController to get admin's name
import '../../services/auth_service.dart'; // Import AuthService for logout

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  // MOCK DATA - In a real app, this would be fetched from services.
  final int totalUpcomingEvents = 3;
  final int pendingApprovalEvents = 1;
  final int totalUsers = 256;
  final double totalRevenue = 12500.50;

  @override
  Widget build(BuildContext context) {
    // Get the UserController to display the admin's name
    final UserController userController = Get.find<UserController>();
    // Use Obx to make the welcome message reactive
    final adminName = userController.user.value?.name ?? 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Use the AuthService for a clean logout
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- WELCOME MESSAGE ---
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

            // --- REDESIGNED STATISTICS SECTION ---
            _buildStatsRow(),
            const SizedBox(height: 24),

            // --- REDESIGNED QUICK ACTIONS SECTION ---
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  // A horizontal row of stats instead of a grid
  Widget _buildStatsRow() {
    final currencyFormat = NumberFormat.currency(locale: 'en_EG', symbol: 'EGP ');
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.event_available,
                label: 'Upcoming',
                value: totalUpcomingEvents.toString(),
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
                value: pendingApprovalEvents.toString(),
                color: Colors.orange.shade800,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.monetization_on,
                label: 'Revenue',
                value: currencyFormat.format(totalRevenue),
                color: Colors.pink.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // A cleaner menu using a Card and ListTiles
  Widget _buildQuickActions(BuildContext context) {
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
                onTap: () => Get.snackbar('Coming Soon', 'User management will be available soon.'),
              ),
              // Conditional "Pending Item" tile for a cleaner look
              if (pendingApprovalEvents > 0) ...[
                const Divider(height: 1),
                _ActionTile(
                  icon: Icons.notification_important_rounded,
                  title: 'Pending Approvals',
                  subtitle: '$pendingApprovalEvents event(s) awaiting review',
                  onTap: () => Get.toNamed('/admin/manage_events'),
                  // Add a visual indicator for pending items
                  trailing: const Icon(Icons.circle, color: Colors.orange, size: 12),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

// --- REDESIGNED WIDGETS FOR THE DASHBOARD ---

// A more compact, horizontal stat card with a gradient
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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

// A reusable ListTile for the action menu
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

