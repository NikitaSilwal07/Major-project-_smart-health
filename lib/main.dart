import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:harry/firebase_options.dart';
import 'package:harry/screens/doctor_home_page.dart';
import 'package:harry/screens/doctor_login_page.dart';
import 'package:harry/screens/user_home_page.dart';
import 'package:harry/screens/user_login_page.dart';
import 'package:harry/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  await NotificationService().initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart_Health',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Custom font
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
      routes: {
        '/doctor_login': (context) => const DoctorLoginPage(),
        '/user_login': (context) => const UserLoginPage(),
        '/doctor_home': (context) => const DoctorHomePage(),
        '/user_home': (context) => const UserHomePage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: const Text(
            'Welcome to Smart_Health',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 5,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4), // Blur effect
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'A Voice-Authenticated eHealthCare Solution',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            offset: Offset(1, 1),
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Experience the future of healthcare with our innovative platform.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    AnimatedButton(
                      label: 'Doctor Login',
                      icon: Icons.medical_services,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/doctor_login'),
                      width: 200,
                    ),
                    const SizedBox(height: 20.0),
                    AnimatedButton(
                      label: 'User Login',
                      icon: Icons.person,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/user_login'),
                      width: 200,
                    ),
                    const SizedBox(height: 40.0),
                    const Text(
                      '© 2024 Smart_Health, All Rights Reserved.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final double width;

  const AnimatedButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.width = double.infinity, // Default full width
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 50), // Smaller size
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
      ).copyWith(
        overlayColor:
            MaterialStateProperty.all(Colors.lightBlue.withOpacity(0.2)),
      ),
    );
  }
}
