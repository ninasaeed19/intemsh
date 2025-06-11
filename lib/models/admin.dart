import 'package:flutter/foundation.dart';

// Assuming you have a User class like this.
// This is added for context and to make the Admin class complete.
class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final DateTime createdAt;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'user',
    required this.createdAt,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
    };
  }
}


class Admin extends User {
  final List<String> managedEvents;
  final List<String> adminPermissions;

  Admin({
    required String id,
    required String email,
    required String name,
    DateTime? createdAt,
    String? profileImageUrl,
    this.managedEvents = const [],
    // Provide a default list of permissions
    this.adminPermissions = const ['manage_events', 'manage_users'],
  }) : super(
    id: id,
    email: email,
    name: name,
    role: 'admin', // Role is correctly hardcoded for an Admin
    createdAt: createdAt ?? DateTime.now(),
    profileImageUrl: profileImageUrl,
  );

  /// A factory to "promote" a standard User to an Admin.
  factory Admin.fromUser(User user) {
    return Admin(
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt,
      profileImageUrl: user.profileImageUrl,
    );
  }

  /// **FIXED:** Added the essential `fromMap` factory for deserialization.

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      profileImageUrl: map['profileImageUrl'],

      managedEvents: List<String>.from(map['managedEvents'] ?? []),
      adminPermissions: List<String>.from(map['adminPermissions'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // Use super.toMap() to include all base user properties
    return {
      ...super.toMap(),
      'managedEvents': managedEvents,
      'adminPermissions': adminPermissions,
    };
  }

  /// **IMPROVEMENT:** Added a `copyWith` method for easily creating
  /// a modified copy of an Admin object.
  Admin copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
    String? profileImageUrl,
    List<String>? managedEvents,
    List<String>? adminPermissions,
  }) {
    return Admin(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      managedEvents: managedEvents ?? this.managedEvents,
      adminPermissions: adminPermissions ?? this.adminPermissions,
    );
  }
}