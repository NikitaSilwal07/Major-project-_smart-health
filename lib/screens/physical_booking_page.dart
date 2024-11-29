import 'package:flutter/material.dart';

class PhysicalBookingPage extends StatelessWidget {
  const PhysicalBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Booking'),
      ),
      body: const Center(
        child: Text(
          'Physical Booking Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
