import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart'; // Your event model

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  // MOCK DATA: In a real app, this would come from a 'BookingsService'
  // that fetches the user's bookings from Firestore.
  final List<Event> _bookedEvents = [
    // Let's assume the user booked these two events.
    Event(
      id: '1',
      title: 'Tech Conference 2025',
      description: 'Join us for the biggest tech conference of the year...',
      location: 'Main Auditorium',
      category: 'Technology',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=500&h=300&fit=crop',
      dateTime: DateTime.now().add(const Duration(days: 10)),
      organizerId: 'admin1',
      maxAttendees: 200,
      attendees: List.generate(180, (index) => 'user$index'),
      isApproved: true,
    ),
    Event(
      id: '3',
      title: 'Annual Sports Gala',
      description: 'Cheer for your favorite teams!',
      location: 'University Stadium',
      category: 'Sports',
      imageUrl: 'https://images.unsplash.com/photo-1579952516518-6c2eac8c13f9?w=500&h=300&fit=crop',
      dateTime: DateTime.now().add(const Duration(days: 30)),
      organizerId: 'admin1',
      maxAttendees: 500,
      attendees: [],
      isApproved: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _bookedEvents.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _bookedEvents.length,
        itemBuilder: (context, index) {
          final event = _bookedEvents[index];
          return _BookingCard(event: event);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Bookings Yet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t booked any events.\nExplore events and book one!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Explore Events'),
            onPressed: () => Get.offAllNamed('/home'),
          )
        ],
      ),
    );
  }
}

// A dedicated widget for a card in the bookings list
class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          // Navigate to the detail screen for this booked event
          Get.toNamed('/event_detail', arguments: event);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Event Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  event.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Event Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    InfoRow(
                      icon: Icons.calendar_today_outlined,
                      text: DateFormat('MMM d, yyyy').format(event.dateTime),
                    ),
                    const SizedBox(height: 4),
                    InfoRow(
                      icon: Icons.location_on_outlined,
                      text: event.location,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// A small helper widget for icon-text rows to avoid code repetition
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}