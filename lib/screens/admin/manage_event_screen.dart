import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../controllers/event_controller.dart';

class ManageEventsScreen extends StatelessWidget {
  const ManageEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find<EventController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Events'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Pending'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [
              _buildEventList(controller.upcomingEvents, 'upcoming'),
              _buildEventList(controller.pendingEvents, 'pending'),
              _buildEventList(controller.pastEvents, 'past'),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed('/admin/create_event'),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEventList(List<Event> events, String status) {
    if (events.isEmpty) {
      return Center(
        child: Text('No ${status.capitalizeFirst} events found.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _AdminEventListItem(event: event, status: status);
      },
    );
  }
}

class _AdminEventListItem extends StatelessWidget {
  final Event event;
  final String status;
  const _AdminEventListItem({required this.event, required this.status});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find<EventController>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(DateFormat('MMM d, y @ hh:mm a').format(event.dateTime), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                _buildPopupMenu(context, event, controller, status),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                _buildInfoChip(Icons.people, '${event.attendees.length} / ${event.maxAttendees}', Colors.blue.shade700),
              ],
            ),
            // **THE FIX**: Conditionally show the "Approve" button.
            if (status == 'pending') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Approve Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => controller.approveEvent(event),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, Event event, EventController controller, String status) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          Get.toNamed('/admin/create_event', arguments: event);
        } else if (value == 'delete') {
          Get.dialog(AlertDialog(
            title: const Text('Delete Event'),
            content: Text('Are you sure you want to permanently delete "${event.title}"?'),
            actions: [
              TextButton(onPressed: Get.back, child: const Text('Cancel')),
              TextButton(
                  onPressed: () { Get.back(); controller.deleteEvent(event.id); },
                  child: const Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          ));
        } else if (value == 'unapprove') {
          controller.unapproveEvent(event);
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        if (status == 'upcoming')
          const PopupMenuItem(value: 'unapprove', child: Text('Move to Pending')),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
