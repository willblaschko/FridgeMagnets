import 'package:audioplayers/audioplayers.dart';

/// A service class for managing sound effects in the app.
class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance for playing sounds

  /// Plays the sound effect for dragging a magnet.
  void playDragSound() {
    _audioPlayer.setVolume(.1); // Set the volume to a low level
    _audioPlayer.play(AssetSource("sounds/drag.mp3")); // Play the drag sound
  }

  /// Plays the sound effect for dropping a magnet.
  void playDropSound() {
    _audioPlayer.setVolume(.1); // Set the volume to a low level
    _audioPlayer.play(AssetSource("sounds/drop.mp3")); // Play the drop sound
  }
}
