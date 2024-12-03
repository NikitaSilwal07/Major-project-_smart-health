import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Colors.teal, // AppBar color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Center(
              child: Text(
                'How Can We Help?',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Primary theme color
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // FAQs Section Header
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey, // Section header color
              ),
            ),
            const SizedBox(height: 12.0),

            // FAQ Items with Color Styling
            Card(
              color: Colors.teal[50], // Light background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ExpansionTile(
                title: Text(
                  'How can I book an appointment?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900], // Text color
                  ),
                ),
                iconColor: Colors.teal, // Expansion icon color
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'To book an appointment, go to the "Appointments" section and select your preferred date and time.',
                      style: TextStyle(color: Colors.teal[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              color: Colors.teal[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ExpansionTile(
                title: Text(
                  'How do I reset my password?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                  ),
                ),
                iconColor: Colors.teal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Click on "Forgot Password" on the login page and follow the instructions to reset your password.',
                      style: TextStyle(color: Colors.teal[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Contact Support Header
            Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12.0),

            // Contact Details with Icon and Text
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.red),
                title: Text('support@smarthealth.com'),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.blue),
                title: Text('+977 9769760968'),
              ),
            ),
            const SizedBox(height: 20.0),

            // Troubleshooting Tips Section
            Text(
              'Troubleshooting Tips',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '• Ensure your app is up to date.\n'
                '• Restart your device if the app crashes.\n'
                '• Allow notifications in your device settings.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.teal[800],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Feedback Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add feedback functionality here
                },
                icon: Icon(Icons.feedback, color: Colors.white),
                label: Text('Send Feedback'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Button color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
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
    );
  }
}
