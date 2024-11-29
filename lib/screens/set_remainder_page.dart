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
      body: '${_medicineController.text} - ${_quantityController.text} tablets',
      scheduledTime: _selectedTime!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder set successfully!')),
    );

    // Return the new reminder to the previous page
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _medicineController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(
                _selectedTime == null
                    ? 'Pick Time'
                    : 'Picked: ${_selectedTime!.hour}:${_selectedTime!.minute}',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleReminder,
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
