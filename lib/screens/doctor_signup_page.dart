import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'audio_input_page.dart'; // Import the audio input page

class DoctorSignupPage extends StatefulWidget {
  const DoctorSignupPage({super.key});

  @override
  _DoctorSignupPageState createState() => _DoctorSignupPageState();
}

class _DoctorSignupPageState extends State<DoctorSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _doctorIDController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _voiceRecorded = false; // Track if voice input is completed
  List<String> _recordedFiles = []; // Store recorded file paths

  void _signUp() async {
    if (_formKey.currentState!.validate() && _voiceRecorded) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Save doctor details to Firestore
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(userCredential.user!.uid)
            .set({
          'userID': _doctorIDController.text, // Save doctorID as userID
          'name': _nameController.text,
          'specialization': _specializationController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'audioFiles': _recordedFiles, // Save recorded file paths
        });

        // Send data to the backend server
        await _sendDataToBackend(_doctorIDController.text, _recordedFiles);

        setState(() {
          _isLoading = false;
        });

        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Sign up successful! Thank you.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Go back to login screen
                },
                child: const Text('Login'),
              ),
            ],
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Show error if voice not recorded
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please complete voice authentication.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _sendDataToBackend(
      String doctorID, List<String> audioFiles) async {
    final uri = Uri.parse('http://192.168.1.79:5000/signin');

    var request = http.MultipartRequest('POST', uri)
      ..fields['speaker'] = doctorID; // Use doctorID instead of userId

    for (String filePath in audioFiles) {
      request.files.add(await http.MultipartFile.fromPath('files', filePath));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Data sent successfully');
      } else {
        print('Failed to send data: ${response.statusCode}');
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        throw Exception(
            'Failed to send data to backend: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending data to backend: $e');
      throw Exception('Error sending data to backend: $e');
    }
  }

  void _navigateToAudioInput() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AudioInputPage(),
      ),
    );
    if (result is List<String>) {
      setState(() {
        _voiceRecorded = true;
        _recordedFiles = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _doctorIDController,
                decoration: const InputDecoration(labelText: 'Doctor ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Doctor ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Specialization'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your specialization';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone No.'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _navigateToAudioInput,
                    icon: const Icon(Icons.mic),
                    label: const Text('Voice Input'),
                  ),
                  const SizedBox(width: 10),
                  if (_voiceRecorded)
                    const Icon(Icons.check, color: Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
