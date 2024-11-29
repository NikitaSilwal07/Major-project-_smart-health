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
      title: 'e-HealthCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      // Define named routes for navigation
      routes: {
        '/doctor_login': (context) => const DoctorLoginPage(),
        '/user_login': (context) => const UserLoginPage(),
        '/doctor_home': (context) => const DoctorHomePage(),
        '/user_home': (context) => const UserHomePage(),
        // Add more routes here as needed
      },
      // Handle unknown routes (if needed)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Smart_Health'),
      ),
      body: Center(
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
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/doctor_login');
              },
              child: const Text('Doctor Login'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user_login');
              },
              child: const Text('User Login'),
            ),
          ],
        ),
      ),
    );
  }
}
