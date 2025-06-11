import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String role; // 'user' or 'admin'
  final DateTime? createdAt;
  final String? profileImageUrl;
  final List<String> registeredEvents;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'user',
    this.createdAt,
    this.profileImageUrl,
    this.registeredEvents = const [],
  });

  /// A factory constructor to create an AppUser from a Firestore document.
  factory AppUser.fromMap(Map<String, dynamic> map, String documentId) {
    return AppUser(
      id: documentId,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      profileImageUrl: map['profileImageUrl'],
      registeredEvents: List<String>.from(map['registeredEvents'] ?? []),
    );
  }

  /// Converts the AppUser object into a Map for storing in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'profileImageUrl': profileImageUrl,
      'registeredEvents': registeredEvents,
    };
  }

  /// Creates a copy of the current user with updated values.
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    DateTime? createdAt,
    String? profileImageUrl,
    List<String>? registeredEvents,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      registeredEvents: registeredEvents ?? this.registeredEvents,
    );
  }

  bool get isAdmin => role == 'admin';
}
