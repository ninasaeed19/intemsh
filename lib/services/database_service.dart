import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import '../models/event.dart'; // Your Event model

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference for events for cleaner code
  late final CollectionReference _eventsCollection;

  DatabaseService() {
    _eventsCollection = _firestore.collection('events');
  }

  /// Fetches all events from the Firestore collection.
  /// Returns a list of Event objects.
  Future<List<Event>> getEvents() async {
    try {
      final querySnapshot = await _eventsCollection.get();
      // Map each document to an Event object using the fromMap factory
      return querySnapshot.docs.map((doc) {
        return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching events: $e');
      }
      // Return an empty list in case of an error
      return [];
    }
  }

  /// Adds a new event to the Firestore collection.
  /// Takes an Event object as input.
  Future<void> addEvent(Event event) async {
    try {
      // Use the toMap method to convert the Event object to a Map
      await _eventsCollection.add(event.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error adding event: $e');
      }
      // Optionally re-throw the error to be handled by the UI
      rethrow;
    }
  }

  /// Updates an existing event in Firestore.
  /// Takes an Event object with an ID.
  Future<void> updateEvent(Event event) async {
    try {
      await _eventsCollection.doc(event.id).update(event.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating event: $e');
      }
      rethrow;
    }
  }

  /// Deletes an event from Firestore using its ID.
  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsCollection.doc(eventId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting event: $e');
      }
      rethrow;
    }
  }

  /// Handles the logic for a user booking an event.
  /// This is a more complex operation that involves two steps for robustness:
  /// 1. Add the user's ID to the event's 'attendees' list.
  /// 2. Create a booking document for the user.
  Future<bool> bookEvent({required String eventId, required String userId}) async {
    try {
      final eventRef = _eventsCollection.doc(eventId);
      final bookingRef = _firestore.collection('users').doc(userId).collection('bookings').doc(eventId);

      // Run a transaction to ensure both operations succeed or fail together
      await _firestore.runTransaction((transaction) async {
        // First, get the latest event document data
        final eventSnapshot = await transaction.get(eventRef);
        if (!eventSnapshot.exists) {
          throw Exception("Event does not exist!");
        }

        // Atomically add the user's ID to the 'attendees' array
        transaction.update(eventRef, {
          'attendees': FieldValue.arrayUnion([userId])
        });

        // Create a new booking record for the user
        transaction.set(bookingRef, {
          'eventId': eventId,
          'bookingDate': FieldValue.serverTimestamp(),
          'paymentStatus': 'paid' // Assuming payment was successful
        });
      });

      return true; // Success
    } catch (e) {
      if (kDebugMode) {
        print('Error booking event: $e');
      }
      return false; // Failure
    }
  }
}