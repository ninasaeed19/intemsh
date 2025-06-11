import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final String imageUrl;
  final DateTime dateTime;
  final String organizerId;
  final int maxAttendees;
  final List<String> attendees;
  final bool isApproved;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.dateTime,
    required this.organizerId,
    required this.maxAttendees,
    required this.attendees,
    required this.isApproved,
  });

  bool get isFull => attendees.length >= maxAttendees;

  /// --- THIS IS THE CRUCIAL FIX ---
  /// A robust getter with detailed logging to diagnose the date issue.
  bool get isPastEvent {
    final now = DateTime.now();

    // This logging will appear in your "Debug Console"
    if (kDebugMode) {
      print("--- Checking 'isPastEvent' for event: $title ---");
      print("Event DateTime:         ${dateTime.toIso8601String()}");
      print("Current DateTime (Now): ${now.toIso8601String()}");
      // The logic: An event is "past" if its date is strictly BEFORE the current moment.
      final result = dateTime.isBefore(now);
      print("Result (is event in the past?): $result");
      print("-------------------------------------------------");
    }

    return dateTime.isBefore(now);
  }

  factory Event.fromMap(Map<String, dynamic> map, String documentId) {
    try {
      return Event(
        id: documentId,
        title: map['title'] ?? 'No Title',
        description: map['description'] ?? 'No Description',
        location: map['location'] ?? 'No Location',
        category: map['category'] ?? 'General',
        imageUrl: map['imageUrl'] ?? '',
        dateTime: (map['datetime'] as Timestamp).toDate(),
        organizerId: map['organizerId'] ?? '',
        maxAttendees: (map['maxAttendees'] as num?)?.toInt() ?? 0,
        attendees: List<String>.from(map['attendees'] ?? []),
        isApproved: map['isApproved'] as bool? ?? false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('--- FATAL PARSING ERROR in Event.fromMap ---');
        print('Could not parse event with ID: $documentId. Error: $e');
        print('Data causing error: $map');
        print('-----------------------------------------');
      }
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'imageUrl': imageUrl,
      'datetime': Timestamp.fromDate(dateTime),
      'organizerId': organizerId,
      'maxAttendees': maxAttendees,
      'attendees': attendees,
      'isApproved': isApproved,
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? category,
    String? imageUrl,
    DateTime? dateTime,
    String? organizerId,
    int? maxAttendees,
    List<String>? attendees,
    bool? isApproved,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      dateTime: dateTime ?? this.dateTime,
      organizerId: organizerId ?? this.organizerId,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      attendees: attendees ?? this.attendees,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}
