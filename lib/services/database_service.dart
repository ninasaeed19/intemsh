import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/booking.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _eventsCollection;

  DatabaseService() {
    _eventsCollection = _firestore.collection('events');
  }

  Stream<List<Event>> getEventsStream() {
    return _eventsCollection.snapshots().map((snapshot) {
      final List<Event> events = [];
      for (final doc in snapshot.docs) {
        try {
          events.add(Event.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        } catch (e) {
          if (kDebugMode) {
            print('--- PARSING ERROR in DatabaseService ---');
            print('Could not parse event with ID: ${doc.id}');
            print('Error Details: $e');
            print('Document Data: ${doc.data()}');
            print('--------------------------------------');
          }
        }
      }
      return events;
    });
  }

  Stream<List<Event>> getUserBookingsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .snapshots()
        .asyncMap((snapshot) async {
      final bookingIds =
      snapshot.docs.map((doc) => Booking.fromMap(doc.data()).eventId).toList();

      if (bookingIds.isEmpty) {
        return [];
      }

      final eventsSnapshot = await _firestore
          .collection('events')
          .where(FieldPath.documentId, whereIn: bookingIds)
          .get();

      return eventsSnapshot.docs
          .map((doc) => Event.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addEvent(Event event) async {
    await _eventsCollection.add(event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await _eventsCollection.doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }

  Future<bool> bookEvent({required String eventId, required String userId}) async {
    try {
      final eventRef = _eventsCollection.doc(eventId);

      // **THE FIX**: Correctly reference the 'bookings' subcollection
      // inside the specific user's document.
      final bookingRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('bookings')
          .doc(eventId); // We can use the eventId as the bookingId for simplicity

      await _firestore.runTransaction((transaction) async {
        final eventSnapshot = await transaction.get(eventRef);
        if (!eventSnapshot.exists) {
          throw Exception("Event does not exist!");
        }
        transaction.update(eventRef, {
          'attendees': FieldValue.arrayUnion([userId])
        });
        transaction.set(bookingRef, {
          'eventId': eventId,
          'bookingDate': FieldValue.serverTimestamp(),
          'paymentStatus': 'paid'
        });
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error booking event: $e');
      }
      rethrow;
    }
  }
}
