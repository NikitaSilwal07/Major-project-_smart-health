import 'package:flutter/material.dart';
import 'dart:math';
import 'audio_recording_page.dart';

class AudioInputPage extends StatefulWidget {
  const AudioInputPage({super.key});

  @override
  _AudioInputPageState createState() => _AudioInputPageState();
}

class _AudioInputPageState extends State<AudioInputPage> {
  final List<String> _audioOptions = [
    "Audio 1",
    "Audio 2",
    "Audio 3",
    "Audio 4",
    "Audio 5"
  ];

  List<String> _recordedFiles = [];

  // Function to generate a random English sentence
  String generateRandomSentence() {
    List<String> sentences = [
      "He strives to keep the best lawn in the neighborhood.The light that burns twice as bright burns half as long.",
      "Her scream silenced the rowdy teenagers.The blue parrot drove by the hitchhiking mongoose.",
      "The tears of a clown make my lipstick run, but my shower cap is still intact.",
      "I enjoy taking long walks in the park during the cool mornings.",
      "Reading a good book by the window is one of my favorite things to do.",
      "On weekends, my family and I love to watch funny movies together.",
      "Cooking a nice meal at home brings me a lot of happiness and joy.",
      "Listening to music can make me feel relaxed and calm after a long day.",
      "Reading a good book by the fireplace is one of my favorite ways to spend a quiet evening at home.",
      "My dog loves to play fetch in the backyard, and we can spend hours running around together.",

    ];

    int randomIndex = Random().nextInt(sentences.length);
    return sentences[randomIndex];
  }

  void _navigateToAudioInput(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AudioRecordingPage(randomSentence: generateRandomSentence()),
      ),
    );
    if (result != null && result is String) {
      // Update the audio option with the recorded file name
      setState(() {
        _audioOptions[index] = "Recorded";
        _recordedFiles[index] = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recordedFiles = List<String>.filled(_audioOptions.length, "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _audioOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_audioOptions[index]),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => _navigateToAudioInput(index),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _recordedFiles);
              },
              child: const Text('Back to Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
