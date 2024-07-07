import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/magnet_model.dart';

/// A service class for managing the storage of magnets.
class StorageService {
  /// Saves the list of magnets to persistent storage.
  ///
  /// [magnets] is the list of magnets to be saved.
  Future<void> saveMagnets(List<MagnetModel> magnets) async {
    final prefs = await SharedPreferences.getInstance(); // Get the shared preferences instance
    final String encodedData = jsonEncode(
      magnets.map((magnet) => magnet.toJson()).toList(), // Convert the list of magnets to JSON
    );
    await prefs.setString('magnets', encodedData); // Save the JSON string to shared preferences
  }

  /// Loads the list of magnets from persistent storage.
  ///
  /// Returns a list of [MagnetModel] objects.
  Future<List<MagnetModel>> loadMagnets() async {
    final prefs = await SharedPreferences.getInstance(); // Get the shared preferences instance
    final String? encodedData = prefs.getString('magnets'); // Retrieve the JSON string from shared preferences
    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData); // Decode the JSON string
      return decodedData.map((item) => MagnetModel.fromJson(item)).toList(); // Convert the JSON objects to MagnetModel instances
    }
    return []; // Return an empty list if no data is found
  }

  /// Shares the list of magnets.
  ///
  /// [magnets] is the list of magnets to be shared.
  Future<void> shareMagnets(List<MagnetModel> magnets) async {
    // Implement sharing functionality here
  }
}
