import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// A widget for selecting text styles for the magnets.
class StyleSelection extends StatelessWidget {
  final Function(TextStyle) onStyleSelected; // Callback for when a style is selected
  late TextStyle selectedStyle; // The currently selected style
  final Function(Color, Color) onCustomStyleSelected; // Callback for when a custom style is selected
  final bool isCustomStyleSelected; // Indicates if the custom style is selected

  /// Constructor for creating a [StyleSelection] widget.
  ///
  /// [onStyleSelected] is the callback for when a style is selected.
  /// [selectedStyle] is the currently selected style.
  /// [onCustomStyleSelected] is the callback for when a custom style is selected.
  /// [isCustomStyleSelected] indicates if the custom style is selected.
  StyleSelection({required this.onStyleSelected, required this.selectedStyle, required this.onCustomStyleSelected, required this.isCustomStyleSelected});

  // Default text style
  static final DEFAULT_STYLE = TextStyle(fontSize: 18, color: Colors.black, backgroundColor: Colors.white);

  // List of available text styles
  static final List<TextStyle> STYLES = [
    DEFAULT_STYLE,
    TextStyle(fontSize: 18, color: Colors.white, backgroundColor: Colors.black),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStyleButton(context, DEFAULT_STYLE, 'Black'),
        _buildStyleButton(context, STYLES[1], 'White'),
        _buildCustomStyleButton(context),
      ],
    );
  }

  /// Builds a button for selecting a text style.
  ///
  /// [context] is the build context.
  /// [style] is the text style for the button.
  /// [label] is the label for the button.
  Widget _buildStyleButton(BuildContext context, TextStyle style, String label) {
    return TextButton(
        onPressed: () => onStyleSelected(style),
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(4),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: (selectedStyle == style && !isCustomStyleSelected) ? Colors.teal : Colors.transparent, width: 2),
            color: style.backgroundColor,
          ),
          child: Text(label, style: style),
        )
    );
  }

  /// Builds a button for selecting a custom text style.
  ///
  /// [context] is the build context.
  Widget _buildCustomStyleButton(BuildContext context) {
    return TextButton(
        onPressed: () => _openColorPickerDialog(context),
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(4),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: isCustomStyleSelected ? Colors.teal : Colors.transparent, width: 2),
            color: DEFAULT_STYLE.backgroundColor,
          ),
          child: Text('Custom', style: DEFAULT_STYLE),
        )
    );
  }

  /// Opens a dialog for selecting custom foreground and background colors.
  ///
  /// [context] is the build context.
  void _openColorPickerDialog(BuildContext context) {
    Color foregroundColor = Colors.black;
    Color backgroundColor = Colors.white;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Colors'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Foreground Color'),
              Container(
                height: 170,
                child: BlockPicker(
                  pickerColor: foregroundColor,
                  availableColors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                    Colors.pink,
                    Colors.brown,
                    Colors.grey,
                    Colors.black,
                    Colors.white,
                  ],
                  onColorChanged: (color) {
                    foregroundColor = color;
                  },
                ),
              ),
              Text('Background Color'),
              Container(
                height: 170,
                child: BlockPicker(
                  pickerColor: backgroundColor,
                  availableColors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                    Colors.pink,
                    Colors.brown,
                    Colors.grey,
                    Colors.black,
                    Colors.white,
                  ],
                  onColorChanged: (color) {
                    backgroundColor = color;
                  },
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Select'),
              onPressed: () {
                selectedStyle = new TextStyle(fontSize: 18);
                onCustomStyleSelected(foregroundColor, backgroundColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
