import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intemssh2/models/event.dart';

class AppHelpers {
  static String formatEventDate(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  static Future<void> showErrorDialog(
      BuildContext context, {
        required String title,
        required String message,
      }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Builds a status chip based on the event's properties.
  /// This now uses the getters from the Event model for cleaner logic.
  static Widget buildEventStatusBadge(Event event) {
    String label;
    Color color;

    if (event.isPastEvent) {
      label = 'PAST';
      color = Colors.grey;
    } else if (!event.isApproved) {
      label = 'PENDING APPROVAL';
      color = Colors.orange.shade800;
    } else if (event.isFull) {
      label = 'FULL';
      color = Colors.red.shade800;
    } else {
      label = 'ACTIVE';
      color = Colors.green.shade800;
    }

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  static String getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final names = name.trim().split(' ');
    if (names.length > 1 && names[1].isNotEmpty) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names[0][0].toUpperCase();
  }
}
