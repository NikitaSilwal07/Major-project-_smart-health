import 'package:flutter/material.dart';
import 'package:harry/screens/audio1_input_page.dart';
import 'package:harry/screens/doctor_home_page.dart';
import 'package:harry/screens/doctor_signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({super.key});

  @override
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _doctorIdController =
      TextEditingController(); // Add this controller for doctor ID input
  String _recordedFilePath = ''; // Add this to store the audio file path
  bool _isLoading = false;
  bool _voiceInputCompleted = false; // Added flag for voice input completion

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate with Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Send audio file to Python server for voice verification
      bool isVoiceAuthenticated = await _sendAudioFileToServer(
        _doctorIdController.text, // Pass the doctor ID from the input field
        _recordedFilePath,
      );

      if (isVoiceAuthenticated) {
        // Handle successful login and voice authentication
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DoctorHomePage()),
        );
      } else {
        _showErrorDialog('Voice Authentication Failed');
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message!);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _sendAudioFileToServer(String doctorId, String filePath) async {
    try {
      var uri = Uri.parse('http://192.168.7.101:5000/login');
      var request = http.MultipartRequest('POST', uri);

      request.fields['test_speaker'] =
          doctorId; // Using the doctor ID as the speaker identifier
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body);
        return jsonResponse['message'] == 'Speaker verified successfully';
      } else {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body);
        _showErrorDialog(jsonResponse['error']);
        return false;
      }
    } catch (e) {
      print('Error sending audio file to server: $e');
      _showErrorDialog('Error sending audio file to server');
      return false;
    }
  }

  void _navigateToAudioInput() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Audio1InputPage()),
    );

    if (result != null && result is String) {
      setState(() {
        _recordedFilePath = result;
        _voiceInputCompleted = true;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Login'),
        actions: [
          // Add the star-shaped button in the top-right corner
          IconButton(
            icon: const Icon(Icons.star), // Star icon
            onPressed: () {
              // Navigate to the DoctorHomePage when clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DoctorHomePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Smart_Health, A voice-authenticated eHealthCare Solution',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller:
                    _doctorIdController, // Add this TextField for doctor ID input
                decoration: const InputDecoration(labelText: 'Doctor ID'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _navigateToAudioInput,
                icon: const Icon(Icons.mic),
                label: Row(
                  children: [
                    const Text('Voice Input'),
                    if (_voiceInputCompleted)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorSignupPage(),
                        ),
                      ).then((_) {
                        _emailController.clear();
                        _passwordController.clear();
                      });
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
