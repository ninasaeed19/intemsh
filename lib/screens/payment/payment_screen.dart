import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/models/event.dart';
import '/services/paymentservice.dart'; // Import the new service

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final Event event = Get.arguments as Event;
  bool _isLoading = false;

  final PaymentService _paymentService = Get.find<PaymentService>();

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      // Call the new PaymentService to handle the logic.
      final bool success = await _paymentService.processPaymentAndBookEvent(event);

      if (mounted) {
        if (success) {
          // On success, navigate to the confirmation screen.
          Get.offNamed('/payment_success', arguments: event);
        } else {
          // On failure, the service already shows a snackbar, so we just stop loading.
          setState(() { _isLoading = false; });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // The rest of your build method remains the same...
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Booking'),
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Processing your payment securely...', style: TextStyle(fontSize: 16)),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Order Summary ---
              const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: Colors.pink.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('1 Ticket'),
                  trailing: const Text(
                    'EGP 150.75', // Mock price
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- FAKE PAYMENT FORM ---
              const Text('Payment Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200)
                ),
                child: const Text(
                  'This is a demo. DO NOT enter your real card details.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cardholder Name'),
                validator: (v) => v!.isEmpty ? 'Please enter the name on the card' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Please enter the card number' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'CVV'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green.shade600
                  ),
                  child: const Text('Pay EGP 150.75 Now', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
