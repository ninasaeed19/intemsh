import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';

class MyBookingsScreen extends StatelessWidget {
  MyBookingsScreen({super.key});

  final List<Event> _bookedEvents = [
    Event(
      id: '1',
      title: 'Tech Conference 2025',
      description: 'The biggest tech conference of the year.',
      location: 'Main Auditorium',
      category: 'Technology',
      imageUrl: 'assets/images/tech.png',
      dateTime: DateTime.now().add(const Duration(days: 10)),
      organizerId: 'admin1',
      maxAttendees: 200,
      attendees: List.generate(180, (i) => 'u$i'),
      isApproved: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
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
          Icon(Icons.event_busy_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          const Text('No Bookings Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => Get.toNamed('/event_detail', arguments: event),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      event.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.broken_image,
                              color: Colors.grey.shade400)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        InfoRow(
                            icon: Icons.calendar_today_outlined,
                            text: DateFormat('MMM d, y').format(event.dateTime)),
                        const SizedBox(height: 4),
                        InfoRow(
                            icon: Icons.location_on_outlined,
                            text: event.location),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
            const Divider(height: 20, thickness: 1),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.qr_code_2),
                label: const Text('View Ticket'),
                onPressed: () {
                  Get.toNamed('/ticket', arguments: event);
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
          child: Text(text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
