import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({super.key});

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _healthIssuesController = TextEditingController();
  String? _selectedDoctorEmail;
  String? _selectedDoctorName;
  List<Map<String, String>> _doctors = [];
  DateTime? _selectedDate;
  List<DateTime> _availableDates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDoctorEmails();
    _setUserEmail();
  }

  Future<void> _fetchDoctorEmails() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('doctors').get();
    final doctors = snapshot.docs.map((doc) {
      return {
        'name': doc['name'] as String,
        'email': doc['email'] as String,
      };
    }).toList();

    setState(() {
      _doctors = doctors;
    });
  }

  Future<void> _setUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
    }
  }

  Future<void> _fetchAvailableDates() async {
    if (_selectedDoctorEmail != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('doctor_schedules')
          .doc(_selectedDoctorEmail!)
          .collection('schedules')
          .get();

      setState(() {
        _availableDates = snapshot.docs
            .map((doc) => DateTime.parse(doc.id))
            .toList()
          ..sort((a, b) => a.compareTo(b));
      });
    }
  }

  Future<void> _registerAppointment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final appointmentData = {
        'name': _nameController.text,
        'age': _ageController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'doctorEmail': _selectedDoctorEmail,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'healthIssues': _healthIssuesController.text,
      };

      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointmentData);

      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Your appointment has been booked successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.blueAccent,
        elevation: 5.0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Online Booking Section
                  const Text(
                    'Online Booking',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField('Name', _nameController),
                        const SizedBox(height: 16),
                        _buildTextField('Age', _ageController,
                            inputType: TextInputType.number),
                        const SizedBox(height: 16),
                        _buildTextField('Phone', _phoneController,
                            inputType: TextInputType.phone),
                        const SizedBox(height: 16),
                        _buildTextField('Email', _emailController,
                            readOnly: true),
                        const SizedBox(height: 16),
                        _buildDoctorDropdown(),
                        const SizedBox(height: 16),
                        _buildDateDropdown(),
                        const SizedBox(height: 16),
                        _buildTextField(
                            'Health Issues', _healthIssuesController),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _registerAppointment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper to create TextFormField widgets
  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false, TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      readOnly: readOnly,
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  // Helper to create Dropdown for doctors
  Widget _buildDoctorDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDoctorEmail,
      decoration: _inputDecoration('Select Doctor'),
      items: _doctors.map((doctor) {
        return DropdownMenuItem(
          value: doctor['email'],
          child: Text(doctor['name']!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDoctorEmail = value;
          _selectedDoctorName =
              _doctors.firstWhere((doctor) => doctor['email'] == value)['name'];
          _selectedDate = null;
          _availableDates = [];
        });
        _fetchAvailableDates();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a doctor';
        }
        return null;
      },
    );
  }

  // Helper to create Dropdown for available dates
  Widget _buildDateDropdown() {
    return DropdownButtonFormField<DateTime>(
      value: _selectedDate,
      decoration: _inputDecoration('Select Date'),
      items: _availableDates.map((date) {
        return DropdownMenuItem(
          value: date,
          child: Text(DateFormat('yyyy-MM-dd').format(date)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDate = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  // Input decoration helper
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blueAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}