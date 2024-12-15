import 'package:flutter/material.dart';
import 'package:harry/services/notification_service.dart';

class SetReminderPage extends StatefulWidget {
  const SetReminderPage({super.key});

  @override
  State<SetReminderPage> createState() => _SetReminderPageState();
}

class _SetReminderPageState extends State<SetReminderPage> {
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    NotificationService().initializeNotifications();
  }

  void _scheduleReminder() {
    if (_selectedTime != null &&
        _medicineController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      NotificationService().scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Time to take your medicine',
        body:
            '${_medicineController.text} - ${_quantityController.text} tablets',
        scheduledTime: _selectedTime!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder set successfully!')),
      );

      Navigator.pop(context, {
        'medicineName': _medicineController.text,
        'quantity': _quantityController.text,
        'time': '${_selectedTime!.hour}:${_selectedTime!.minute}',
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
    }
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set a Reminder',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _medicineController,
              decoration: InputDecoration(
                labelText: 'Medicine Name',
                prefixIcon: const Icon(Icons.medical_services, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                prefixIcon: const Icon(Icons.format_list_numbered,
                    color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.timer),
              label: Text(
                _selectedTime == null
                    ? 'Pick Time'
                    : 'Picked: ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16.0),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _scheduleReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Set Reminder',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
