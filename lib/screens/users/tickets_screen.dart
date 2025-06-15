import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/event.dart';
import '../../controllers/user_controller.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the event and user data from the controllers
    final Event event = Get.arguments as Event;
    final UserController userController = Get.find<UserController>();
    final String userName = userController.user.value?.name ?? 'Guest User';
    final String userId = userController.user.value?.id ?? 'guest';

    // The data to be encoded in the QR code.
    // In a real system, this would be a unique booking ID.
    final String qrData = 'EventID:${event.id};UserID:$userId';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Event Ticket'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // QR Code
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.black,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Event and User Details
                Text(
                  event.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ticket for: $userName',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: DateFormat('EEEE, MMM d, y @ hh:mm a').format(event.dateTime),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  text: event.location,
                ),
                const SizedBox(height: 20),
                Text(
                  'Please present this QR code at the event entrance for scanning.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.pink, size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
