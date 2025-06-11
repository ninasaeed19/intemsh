import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For better date formatting
import 'package:intemssh2/models/event.dart';
import 'package:intemssh2/utils/constants.dart';
import 'package:intemssh2/utils/helpers.dart'; // To use our status badge

class EventCard extends StatelessWidget {
  final Event event;
  final bool isAdmin;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.isAdmin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepPink,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Show the status badge for both admins and users
                  AppHelpers.buildEventStatusBadge(event),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.calendar_today,
                // Using 'intl' for professional date formatting
                text: DateFormat('MMM dd, yyyy  •  hh:mm a').format(event.dateTime),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.location_on,
                text: event.location,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.darkPink),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.darkGray, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
