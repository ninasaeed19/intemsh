import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intemssh2/models/event.dart';
import 'package:intemssh2/models/appuser.dart'; // The simple user model from above

class ViewAttendeesScreen extends StatefulWidget {
  const ViewAttendeesScreen({super.key});

  @override
  State<ViewAttendeesScreen> createState() => _ViewAttendeesScreenState();
}

class _ViewAttendeesScreenState extends State<ViewAttendeesScreen> {
  // --- MOCK USER DATABASE ---
  // In a real app, you would have a service to fetch user details from Firestore.
  final List<AppUser> _allUsers = List.generate(
    200,
        (index) => AppUser(
      id: 'user$index',
      name: 'Attendee Name ${index + 1}',
      email: 'attendee${index + 1}@university.edu.eg', createdAt: null,
    ),
  );

  late Event _event;
  late List<AppUser> _attendees;

  @override
  void initState() {
    super.initState();
    // Get the event passed from the previous screen
    _event = Get.arguments as Event;

    // Simulate fetching user details for each attendee ID
    _attendees = _event.attendees.map((attendeeId) {
      // Find the user in our mock database.
      // In a real app, this would be an async call to Firestore.
      return _allUsers.firstWhere(
            (user) => user.id == attendeeId,
        orElse: () => AppUser(id: attendeeId, name: 'student', email: '', createdAt: null),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Attendees'),
        actions: [
          // A button to export the list (dummy action for now)
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              Get.snackbar(
                  'Exporting List',
                  'Generating a CSV of attendees for "${_event.title}".',
                  snackPosition: SnackPosition.BOTTOM
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _event.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    '${_attendees.length} / ${_event.maxAttendees} Attendees',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                  avatar: Icon(Icons.people, color: Theme.of(context).primaryColor),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- ATTENDEE LIST ---
          Expanded(
            child: _attendees.isEmpty
                ? const Center(
              child: Text(
                'No one has booked this event yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _attendees.length,
              itemBuilder: (context, index) {
                final attendee = _attendees[index];
                // Display each attendee in a styled list tile
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink.shade100,
                      child: Text(
                        // Get initials from the name
                        attendee.name.isNotEmpty ? attendee.name.substring(0, 1) : '?',
                        style: TextStyle(color: Colors.pink.shade800, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(attendee.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(attendee.email),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}