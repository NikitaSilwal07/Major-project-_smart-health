import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentBookedPage extends StatefulWidget {
  const AppointmentBookedPage({super.key});

  @override
  _AppointmentBookedPageState createState() => _AppointmentBookedPageState();
}

class _AppointmentBookedPageState extends State<AppointmentBookedPage> {
  final _currentUserEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Appointments'),
        backgroundColor: Colors.teal, // More appealing color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorEmail', isEqualTo: _currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                strokeWidth: 4.0,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'No appointments found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment =
                  appointments[index].data() as Map<String, dynamic>;
              final name = appointment['name'];
              final age = appointment['age'];
              final phone = appointment['phone'];
              final email = appointment['email'];
              final appointmentTime = appointment['appointmentTime'];
              final appointmentDate = appointment['appointmentDate'];
              final healthIssues = appointment['healthIssues'];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Card(
                  elevation: 10.0, // More pronounced shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16.0), // More rounded corners
                  ),
                  color:
                      Colors.teal.shade50, // Subtle background color for cards
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Patient: $name',
                        style: TextStyle(
                          fontSize: 20.0, // Larger title
                          fontWeight: FontWeight.w600,
                          color: Colors.teal.shade900,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAppointmentDetail(
                              Icons.calendar_today, 'Age', '$age'),
                          _buildAppointmentDetail(Icons.phone, 'Phone', phone),
                          _buildAppointmentDetail(Icons.email, 'Email', email),
                          _buildAppointmentDetail(
                              Icons.date_range, 'Date', appointmentDate),
                          _buildAppointmentDetail(
                              Icons.access_time, 'Time', appointmentTime),
                          _buildAppointmentDetail(Icons.medical_services,
                              'Health Issues', healthIssues),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper method to create each appointment detail with an icon
  Widget _buildAppointmentDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal.shade700, size: 22.0), // Larger icons
          const SizedBox(width: 12.0),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
              fontWeight: FontWeight.w500, // Bold text for better emphasis
            ),
          ),
        ],
      ),
    );
  }
}