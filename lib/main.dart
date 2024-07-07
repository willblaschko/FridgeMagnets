import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'screens/fridge_door.dart';

/// Main entry point for the Fridge Magnet Poetry App
void main() {
  runApp(FridgeMagnetPoetryApp());
}

/// The root widget of the Fridge Magnet Poetry App
class FridgeMagnetPoetryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge Magnet Poetry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FridgeDoor(), // The main screen of the app
    );
  }

  /// Prepares the audio settings for text-to-speech functionality
  void prepareAudio() async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setSharedInstance(true); // Set the TTS instance to be shared
  }
}
