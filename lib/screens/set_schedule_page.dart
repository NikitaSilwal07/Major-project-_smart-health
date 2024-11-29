import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SetSchedulePage extends StatefulWidget {
  const SetSchedulePage({super.key});

  @override
  _SetSchedulePageState createState() => _SetSchedulePageState();
}

class _SetSchedulePageState extends State<SetSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<DateTime, TextEditingController> _scheduleControllers = {};
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  User? _currentUser;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _scheduleControllers[_selectedDate] = TextEditingController();
    _fetchExistingSchedules();
  }

  void _fetchExistingSchedules() async {
    if (_currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('doctor_schedules')
          .doc(_currentUser!.email!)
          .collection('schedules')
          .get();

      setState(() {
        for (var doc in snapshot.docs) {
          final DateTime date = DateTime.parse(doc.id);
          if (doc.data()['schedule'] is String) {
            final String scheduleText = doc.data()['schedule'];
            _scheduleControllers[date] =
                TextEditingController(text: scheduleText);
          }
        }
      });
    }
  }

  void _saveSchedule() async {
    if (_formKey.currentState!.validate()) {
      if (_currentUser != null && _startTime != null && _endTime != null) {
        final String scheduleText =
            '${_startTime!.format(context)} - ${_endTime!.format(context)}';

        await FirebaseFirestore.instance
            .collection('doctor_schedules')
            .doc(_currentUser!.email!)
            .collection('schedules')
            .doc(_selectedDate.toIso8601String().split('T').first)
            .set({
          'schedule': scheduleText,
        });

        setState(() {
          _scheduleControllers[_selectedDate]!.text = scheduleText;
          _startTime = null;
          _endTime = null;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Your schedule has been saved successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select start and end times.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      if (!_scheduleControllers.containsKey(selectedDay)) {
        _scheduleControllers[selectedDay] = TextEditingController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _selectedDate,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _selectedDate = focusedDay;
                },
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Schedule for ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectTime(context, true),
                          child: const Text('Set Start Time'),
                        ),
                        const SizedBox(width: 10.0),
                        if (_startTime != null)
                          Text('Start: ${_startTime!.format(context)}'),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectTime(context, false),
                          child: const Text('Set End Time'),
                        ),
                        const SizedBox(width: 10.0),
                        if (_endTime != null)
                          Text('End: ${_endTime!.format(context)}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSchedule,
                child: const Text('Save Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
