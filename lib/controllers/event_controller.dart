import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';

class EventController extends GetxController {
  static EventController get to => Get.find();

  final RxList<Event> allEvents = <Event>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    final List<Event> mockEvents = [
      Event(id: '1', title: 'Tech Conference 2025', description: '...', location: 'Main Auditorium', category: 'Technology', imageUrl: 'assets/images/tech.png', dateTime: DateTime.now().add(const Duration(days: 10)), organizerId: 'admin1', maxAttendees: 200, attendees: List.generate(180, (i) => 'u$i'), isApproved: true),
      Event(id: '2', title: 'Art Exhibition Opening', description: '...', location: 'Fine Arts Gallery', category: 'Arts & Culture', imageUrl: 'assets/images/art.png', dateTime: DateTime.now().add(const Duration(days: 15)), organizerId: 'admin2', maxAttendees: 100, attendees: List.generate(20, (i) => 'u$i'), isApproved: true),
      Event(id: '3', title: 'Annual Sports Gala', description: '...', location: 'University Stadium', category: 'Sports', imageUrl: 'assets/images/sports.png', dateTime: DateTime.now().add(const Duration(days: 30)), organizerId: 'admin1', maxAttendees: 500, attendees: [], isApproved: false),
    ];
    allEvents.assignAll(mockEvents);
    isLoading.value = false;
  }

  List<Event> get upcomingEvents => allEvents.where((e) => e.isApproved && !e.isPastEvent).toList();
  List<Event> get pendingEvents => allEvents.where((e) => !e.isApproved && !e.isPastEvent).toList();
  List<Event> get pastEvents => allEvents.where((e) => e.isPastEvent).toList();

  Future<bool> saveEvent(Event eventFromForm, bool isEditing) async {
    if (isEditing) {
      final index = allEvents.indexWhere((e) => e.id == eventFromForm.id);
      if (index != -1) {
        allEvents[index] = eventFromForm;
        Get.snackbar('Success', 'Event updated!', backgroundColor: Colors.green, colorText: Colors.white);
      }
    } else {
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: eventFromForm.title,
        description: eventFromForm.description,
        location: eventFromForm.location,
        category: eventFromForm.category,
        imageUrl: eventFromForm.imageUrl,
        dateTime: eventFromForm.dateTime,
        maxAttendees: eventFromForm.maxAttendees,
        organizerId: 'admin_mock_id',
        attendees: [],
        isApproved: true,
      );
      allEvents.add(newEvent);
      Get.snackbar('Success', 'Event created!', backgroundColor: Colors.green, colorText: Colors.white);
    }
    return true;
  }

  Future<void> deleteEvent(String eventId) async {
    allEvents.removeWhere((e) => e.id == eventId);
    Get.snackbar('Success', 'Event has been deleted.', backgroundColor: Colors.orange, colorText: Colors.white);
  }

  Future<void> approveEvent(Event event) async {
    final index = allEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final approvedEvent = event.copyWith(isApproved: true);
      allEvents[index] = approvedEvent;
      Get.snackbar('Success', '"${event.title}" has been approved.', backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  /// **NEW METHOD**: Un-approves an event and moves it back to pending.
  Future<void> unapproveEvent(Event event) async {
    final index = allEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      // Create a copy of the event with 'isApproved' set to false.
      final unapprovedEvent = event.copyWith(isApproved: false);
      // Replace the old event in the list with the updated one.
      allEvents[index] = unapprovedEvent;
      Get.snackbar('Success', '"${event.title}" has been moved to pending.', backgroundColor: Colors.blue, colorText: Colors.white);
    }
  }
}
