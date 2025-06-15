import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String eventId;
  final DateTime bookingDate;

  Booking({
    required this.eventId,
    required this.bookingDate,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      eventId: map['eventId'] ?? '',
      bookingDate: (map['bookingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
