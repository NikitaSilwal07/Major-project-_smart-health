import 'package:flutter/material.dart';
import 'package:harry/screens/appoinment_booked_page.dart';
import 'package:harry/screens/set_schedule_page.dart'; // Import the set schedule page

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Doctor!',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AppointmentBookedPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Different color for this button
              ),
              child: const Text('Appointments'),
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SetSchedulePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Different color for this button
              ),
              child: const Text('Set Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
