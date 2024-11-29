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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorEmail', isEqualTo: _currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found'));
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

              return Card(
                child: ListTile(
                  title: Text('Patient: $name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age: $age'),
                      Text('Phone: $phone'),
                      Text('Email: $email'),
                      Text('Date: $appointmentDate'),
                      Text('Time: $appointmentTime'),
                      Text('Health Issues: $healthIssues'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
