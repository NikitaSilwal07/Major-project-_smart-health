import 'package:flutter/material.dart';

class MedicalReportPage extends StatelessWidget {
  const MedicalReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Report'),
      ),
      body: const Center(
        child: Text('Medical Report Page'),
      ),
    );
  }
}
