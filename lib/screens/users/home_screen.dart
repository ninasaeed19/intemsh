import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../controllers/event_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find<EventController>();
    final List<String> categories = ['Technology', 'Arts & Culture', 'Sports', 'Networking', 'Music'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by event name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Obx(() => ChoiceChip(
                          label: const Text('All'),
                          selected: controller.selectedCategory.value == '',
                          onSelected: (selected) {
                            controller.selectedCategory.value = '';
                          },
                        ));
                      }
                      final category = categories[index - 1];
                      return Obx(() => ChoiceChip(
                        label: Text(category),
                        selected: controller.selectedCategory.value == category,
                        onSelected: (selected) {
                          controller.selectedCategory.value = category;
                        },
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final events = controller.filteredUpcomingEvents;

              if (events.isEmpty) {
                return const Center(
                  child: Text(
                    'No events found.\nTry adjusting your search or filters.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(event: event);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final availableSeats = event.maxAttendees - event.attendees.length;
    return GestureDetector(
      onTap: () => Get.toNamed('/event_detail', arguments: event),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'event_image_${event.id}',
              child: Image.asset(
                event.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.broken_image, color: Colors.grey.shade400, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(event.category.toUpperCase()),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  InfoRow(icon: Icons.calendar_today_outlined, text: DateFormat('MMM d, y @ hh:mm a').format(event.dateTime)),
                  const SizedBox(height: 4),
                  InfoRow(icon: Icons.location_on_outlined, text: event.location),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      event.isFull
                          ? const Text('Event Full', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red))
                          : Text('$availableSeats seats left', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFC2185B))),
                      Row(
                        children: [
                          Text('View Details', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).primaryColor),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
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
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade800), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
