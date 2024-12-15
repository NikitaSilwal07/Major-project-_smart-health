import 'package:flutter/material.dart';

class AmbulanceBookingPage extends StatelessWidget {
  const AmbulanceBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ambulance Booking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 8.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                const Text(
                  'Book an Ambulance',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Please provide your information to proceed with the ambulance booking.',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
                const SizedBox(height: 30.0),

                // Card for the input fields
                Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Input Field
                        _buildInputField(
                          label: 'Full Name',
                          icon: Icons.person,
                          hintText: 'Enter your full name',
                        ),
                        const SizedBox(height: 15.0),

                        // Address Input Field
                        _buildInputField(
                          label: 'Address',
                          icon: Icons.location_on,
                          hintText: 'Enter your address',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 15.0),

                        // Emergency Contact Input Field
                        _buildInputField(
                          label: 'Emergency Contact',
                          icon: Icons.phone,
                          hintText: 'Enter emergency contact number',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20.0),

                        // Date of Pickup Section (Optional)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () {
                                // Add functionality for selecting date
                              },
                              color: Colors.redAccent,
                            ),
                            const Text(
                              'Pick a Date for Ambulance Pickup',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),

                        // Book Ambulance Button
                        _buildGradientButton(
                          context,
                          label: 'Book Ambulance',
                          onPressed: () {
                            // Booking logic goes here
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Booking Confirmed'),
                                content: const Text('Your ambulance has been booked.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField({
    required String label,
    required IconData icon,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  // Helper method for the gradient button
  Widget _buildGradientButton(BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        backgroundColor: Colors.redAccent,  // Replaced 'primary' with 'backgroundColor'
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 8.0,
        shadowColor: Colors.redAccent.shade200,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );
  }
}