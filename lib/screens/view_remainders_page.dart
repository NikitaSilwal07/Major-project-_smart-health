import 'package:flutter/material.dart';
import 'set_remainder_page.dart';

class ViewRemindersPage extends StatefulWidget {
  const ViewRemindersPage({super.key});

  @override
  State<ViewRemindersPage> createState() => _ViewRemindersPageState();
}

class _ViewRemindersPageState extends State<ViewRemindersPage> {
  final List<Map<String, String>> _reminders = [];

  void _addReminder(Map<String, String> reminder) {
    setState(() {
      _reminders.add(reminder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reminders'),
      ),
      body: _reminders.isEmpty
          ? const Center(
              child: Text('No reminders yet! Tap the "+" button to add one.'),
            )
          : ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return ListTile(
                  title: Text(reminder['medicineName'] ?? 'Unknown Medicine'),
                  subtitle: Text(
                    'Quantity: ${reminder['quantity']} | Time: ${reminder['time']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _reminders.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SetReminderPage()),
          );

          if (result != null && result is Map<String, String>) {
            _addReminder(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
