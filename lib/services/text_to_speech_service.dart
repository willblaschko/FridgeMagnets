import 'package:flutter_tts/flutter_tts.dart';
import '../models/magnet_model.dart';

/// A service class for managing text-to-speech functionality.
class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts(); // Instance of FlutterTts for text-to-speech

  /// Reads the poetry aloud using text-to-speech.
  ///
  /// [magnets] is the list of magnets to be read aloud.
  Future<void> readPoetry(List<MagnetModel> magnets) async {
    // Sort magnets from top to bottom, left to right
    magnets.sort((a, b) {
      if (a.position.dy == b.position.dy) {
        return a.position.dx.compareTo(b.position.dx);
      }
      return a.position.dy.compareTo(b.position.dy);
    });

    // Group magnets into lines based on their vertical positions
    List<List<MagnetModel>> lines = [];
    List<MagnetModel> currentLine = [];
    double currentLineTop = magnets.first.position.dy;
    double currentLineBottom = magnets.first.position.dy;

    for (MagnetModel magnet in magnets) {
      if (magnet.position.dy <= currentLineBottom + 20) { // Assuming 20 as the threshold for a new line
        currentLine.add(magnet);
        currentLineTop = currentLineTop < magnet.position.dy ? currentLineTop : magnet.position.dy;
        currentLineBottom = currentLineBottom > magnet.position.dy ? currentLineBottom : magnet.position.dy;
      } else {
        lines.add(currentLine);
        currentLine = [magnet];
        currentLineTop = magnet.position.dy;
        currentLineBottom = magnet.position.dy;
      }
    }
    lines.add(currentLine); // Add the last line

    // Concatenate the text of all magnets with pauses for dramatic effect
    String poetryText = '';
    for (List<MagnetModel> line in lines) {
      line.sort((a, b) => a.position.dx.compareTo(b.position.dx)); // Sort each line from left to right
      for (MagnetModel magnet in line) {
        poetryText += magnet.text + ' ';
      }
      poetryText += '... '; // Adding pauses for dramatic effect at the end of each line
    }

    // Set TTS settings for a more poetic reading
    await _flutterTts.setSpeechRate(0.4); // Slower speech rate
    await _flutterTts.setPitch(0.7); // Normal pitch

    // Speak the concatenated text
    await _flutterTts.speak(poetryText);
  }

  /// Returns the sorted poetry text from the list of magnets.
  ///
  /// [magnets] is the list of magnets to be sorted.
  /// Returns a string representing the sorted poetry text.
  String getSortedPoetryText(List<MagnetModel> magnets) {
    // Sort magnets from top to bottom, left to right
    magnets.sort((a, b) {
      if (a.position.dy == b.position.dy) {
        return a.position.dx.compareTo(b.position.dx);
      }
      return a.position.dy.compareTo(b.position.dy);
    });

    // Concatenate the text of all magnets
    return magnets.map((magnet) => magnet.text).join(' ');
  }
}
