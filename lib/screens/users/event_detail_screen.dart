import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Event event = Get.arguments as Event;

    String buttonText;
    VoidCallback? onPressedAction;
    Color buttonColor;

    if (event.isPastEvent) {
      buttonText = 'Event Has Ended';
      onPressedAction = null;
      buttonColor = Colors.grey;
    } else if (event.isFull) {
      buttonText = 'Event Is Full';
      onPressedAction = null;
      buttonColor = Colors.red.shade400;
    } else {
      buttonText = 'Book Now';
      buttonColor = Theme.of(context).primaryColor;
      onPressedAction = () => Get.toNamed('/payment', arguments: event);
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: ElevatedButton(
            onPressed: onPressedAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(buttonText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10, color: Colors.black54)]),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
              background: Hero(
                tag: 'event_image_${event.id}',
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.4),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.broken_image, color: Colors.grey.shade400, size: 50),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(event.category.toUpperCase()),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(context, event),
                  const SizedBox(height: 24),
                  const Text('About this Event', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(event.description, style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey.shade800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Event event) {
    final availableSeats = event.maxAttendees - event.attendees.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildInfoRow(icon: Icons.calendar_today_outlined, title: 'Date & Time', subtitle: DateFormat('EEEE, MMMM d, y \'at\' hh:mm a').format(event.dateTime)),
          const Divider(height: 24),
          _buildInfoRow(icon: Icons.location_on_outlined, title: 'Location', subtitle: event.location),
          const Divider(height: 24),
          _buildInfoRow(icon: Icons.people_outline, title: 'Attendees', subtitle: '${event.attendees.length} / ${event.maxAttendees} (${event.isFull ? "Full" : "$availableSeats spots left"})'),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.pink.shade700, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.grey.shade800)),
            ],
          ),
        ),
      ],
    );
  }
}
