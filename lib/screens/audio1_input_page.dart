import 'package:flutter/material.dart';
import 'dart:math';
import 'audio1_recording_page.dart'; // Import the audio1 recording page

class Audio1InputPage extends StatelessWidget {
  final List<String> _audioOptions = [
    "Audio 1",
  ];

  Audio1InputPage({super.key});

  // Function to generate a random English sentence
  String generateRandomSentence() {
    List<String> sentences = [
     "He strives to keep the best lawn in the neighborhood.The light that burns twice as bright burns half as long.",
      "Her scream silenced the rowdy teenagers.The blue parrot drove by the black monkey.",
      "The tears of a clown make my lipstick run, but my shower cap is still untouched.",
      "I enjoy taking long walks in the park during the cool mornings.",
      "Reading a good book by the window is one of my favorite things to do in a rainy day.",
      "On weekends, my family and I love to watch funny movies together.",
      "Cooking a nice meal at home brings me a lot of happiness and joy.",
      "Listening to music can make me feel relaxed and calm after a long day.",
      "Reading a good book by the fireplace is one of my favorite ways to spend a quiet evening at home.",
      "My dog loves to play fetch in the backyard, and we can spend hours running around together.",
      // Add more sentences as needed
    ];

    int randomIndex = Random().nextInt(sentences.length);
    return sentences[randomIndex];
  }

  void _navigateToAudioRecording(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Audio1RecordingPage(randomSentence: generateRandomSentence()),
      ),
    );

    if (result != null && result is String) {
      // If the result is a string (file path), handle it as needed
      // For example, you might want to pass this file path back to the login page
      Navigator.pop(context, result);
    }
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
                  onTap: () => _navigateToAudioRecording(context, index),
                );
              },
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login page
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
