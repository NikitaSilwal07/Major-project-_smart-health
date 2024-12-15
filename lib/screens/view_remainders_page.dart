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
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_off,
                    size: 80.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No reminders yet!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Tap the arrow button to add a new reminder.',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: const Icon(
                        Icons.medical_services,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      reminder['medicineName'] ?? 'Unknown Medicine',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      'Quantity: ${reminder['quantity']} | Time: ${reminder['time']}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _reminders.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reminder deleted!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
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
        backgroundColor: Colors.teal,
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
