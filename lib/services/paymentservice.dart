import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';

class PaymentService extends GetxService {
  static PaymentService get to => Get.find();

  Future<bool> processPaymentAndBookEvent(Event event) async {
    try {
      await Future.delayed(const Duration(seconds: 3));

      const bool paymentSuccessful = true;

      if (paymentSuccessful) {
        return true;
      } else {
        throw Exception("Your payment could not be processed.");
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('An Error Occurred', style: TextStyle(color: Colors.red)),
          content: SelectableText('Something went wrong. Please try again.\n\n$e'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
      return false;
    }
  }
}
