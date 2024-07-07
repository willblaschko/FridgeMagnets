import 'package:flutter/material.dart';

/// A model representing a magnet with text, style, position, and colors.
class MagnetModel {
  String text; // The text displayed on the magnet
  TextStyle style; // The style of the text on the magnet
  Offset position; // The position of the magnet on the screen
  Color foregroundColor; // The foreground color of the text on the magnet
  Color backgroundColor; // The background color of the magnet

  /// Constructor for creating a [MagnetModel].
  ///
  /// [text] is the text displayed on the magnet.
  /// [style] is the style of the text on the magnet.
  /// [position] is the position of the magnet on the screen.
  /// [foregroundColor] is the foreground color of the text on the magnet.
  /// [backgroundColor] is the background color of the magnet.
  MagnetModel({required this.text, required this.style, required this.position, required this.foregroundColor, required this.backgroundColor});

  /// Converts the [MagnetModel] to a JSON object.
  Map<String, dynamic> toJson() => {
        'text': text,
        'style': {
          'fontFamily': style.fontFamily,
          'fontSize': style.fontSize,
          'color': style.color?.value,
          'backgroundColor': style.backgroundColor?.value
        },
        'position': {'dx': position.dx, 'dy': position.dy},
        'foregroundColor': foregroundColor.value,
        'backgroundColor': backgroundColor.value,
      };

  /// Creates a [MagnetModel] from a JSON object.
  ///
  /// [json] is the JSON object representing a [MagnetModel].
  factory MagnetModel.fromJson(Map<String, dynamic> json) => MagnetModel(
        text: json['text'],
        style: TextStyle(
          fontFamily: json['style']['fontFamily'],
          fontSize: json['style']['fontSize'],
          color: Color(json['style']['color']),
          backgroundColor: Color(json['style']['backgroundColor'])
        ),
        position: Offset(json['position']['dx'], json['position']['dy']),
        foregroundColor: Color(json['foregroundColor']),
        backgroundColor: Color(json['backgroundColor']),
      );
}
