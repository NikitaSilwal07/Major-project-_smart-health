import 'package:flutter/material.dart';
import 'package:harry/screens/audio1_input_page.dart';
import 'package:harry/screens/user_signup_page.dart';
import 'package:harry/screens/user_home_page.dart'; // Import user home page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userIdController =
      TextEditingController(); // Add this controller for user ID input
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
        _userIdController.text, // Pass the user ID from the input field
        _recordedFilePath,
      );

      if (isVoiceAuthenticated) {
        // Handle successful login and voice authentication
        Navigator.pushReplacementNamed(context, '/user_home');
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

  Future<bool> _sendAudioFileToServer(String userId, String filePath) async {
    try {
      var uri = Uri.parse('http://192.168.1.79:5000/login');
      var request = http.MultipartRequest('POST', uri);

      request.fields['test_speaker'] =
          userId; // Using the user ID as the speaker identifier
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

  void _navigateToUserHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Login'),
        actions: [
          IconButton(
            onPressed: _navigateToUserHome, // Navigate to user home page
            icon: const Icon(
              Icons.star, // Star-shaped button icon
              color: Color.fromARGB(255, 41, 38, 11),
            ),
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
                    _userIdController, // Add this TextField for user ID input
                decoration: const InputDecoration(labelText: 'User ID'),
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
                          builder: (context) => const UserSignupPage(),
                        ),
                      );
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
