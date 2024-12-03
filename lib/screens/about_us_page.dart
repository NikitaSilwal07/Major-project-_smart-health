import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.teal, // AppBar background color
      ),
      body: Container(
        color: Colors.teal[50], // Light background color for the page
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  'About Our App',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800], // Primary theme color
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Description
              Text(
                'Our app simplifies healthcare by providing essential features like booking appointments, accessing medical records, and setting reminders—all in one place.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800], // Neutral text color
                ),
              ),
              const SizedBox(height: 24.0),

              // Key Features Section
              Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Section header color
                ),
              ),
              const SizedBox(height: 8.0),

              // Feature Items with Icons
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.teal[700]),
                  title: Text('Appointment Booking'),
                  subtitle: Text('Easily schedule appointments with doctors.'),
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.notifications_active,
                      color: Colors.orange[700]),
                  title: Text('Set Reminders'),
                  subtitle: Text(
                      'Get timely alerts for your medications and appointments.'),
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.report, color: Colors.green[700]),
                  title: Text('Medical Reports'),
                  subtitle: Text('Access and manage your medical records.'),
                ),
              ),
              const SizedBox(height: 24.0),

              // Contact Section
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 12.0),

              // Contact Details with Icons
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.email, color: Colors.red),
                      const SizedBox(width: 8.0),
                      Text(
                        'support@smarthealth.com',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      const SizedBox(width: 8.0),
                      Text(
                        '+977 9769760968',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Rate Us Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add functionality for rating the app here
                  },
                  icon: const Icon(Icons.star, color: Colors.white),
                  label: const Text('Rate Us'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700], // Button background color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
