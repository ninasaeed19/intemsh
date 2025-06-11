import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intemssh2/models/event.dart';
import 'package:intemssh2/screens/users/event_detail_screen.dart';
import 'package:intemssh2/widgets/event_card.dart'; // Correct path to widgets
import 'package:intemssh2/utils/constants.dart';
import 'package:intemssh2/users/admin/admin_dashboard.dart';
import 'package:intemssh2/screens/admin/create_event_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;

  // The 'isAdmin' flag should be passed in from main.dart's AuthWrapper
  const HomeScreen({super.key, required this.isAdmin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null && mounted) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (mounted) {
        setState(() {
          _userName = userDoc.data()?['name'] ?? 'User';
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.palePink,
      appBar: AppBar(
        title: Text(_userName.isNotEmpty ? 'Welcome, $_userName' : 'Events'),
        backgroundColor: AppColors.primaryPink,
        actions: [
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.dashboard_customize),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),
              tooltip: 'Admin Dashboard',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _buildEventList(),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen())),
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _buildEventList() {
    // --- This is the key logic for providing role-specific views ---
    Query query;

    if (widget.isAdmin) {
      // Admins see all events, newest first, for management.
      query = FirebaseFirestore.instance.collection('events').orderBy('datetime', descending: true);
    } else {
      // Users only see approved, upcoming events.
      query = FirebaseFirestore.instance
          .collection('events')
          .where('isApproved', isEqualTo: true)
          .where('datetime', isGreaterThanOrEqualTo: DateTime.now())
          .orderBy('datetime');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryPink));
        }

        // --- THIS IS THE CORRECTED MAPPING LOGIC ---
        final events = snapshot.data!.docs.map((doc) {
          // We pass the document ID along with the data map
          return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        if (events.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.isAdmin ? 'Event Management' : 'Upcoming Events',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.deepPink),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    event: event,
                    isAdmin: widget.isAdmin,
                    // The onTap now correctly navigates to the detail screen
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy, size: 60, color: AppColors.lightPink),
          const SizedBox(height: 16),
          Text(
            widget.isAdmin ? 'No events found.' : 'No upcoming events right now.',
            style: const TextStyle(color: AppColors.darkPink, fontSize: 18),
          ),
          if (widget.isAdmin)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Create one using the \'+\' button!',
                style: TextStyle(color: AppColors.darkGray),
              ),
            ),
        ],
      ),
    );
  }
}
