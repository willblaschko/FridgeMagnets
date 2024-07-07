import 'package:flutter/material.dart';

/// A widget for entering custom words to be added as magnets.
class CustomWordEntry extends StatelessWidget {
  final Function(String) onWordAdded; // Callback for when a word is added

  /// Constructor for creating a [CustomWordEntry] widget.
  ///
  /// [onWordAdded] is the callback for when a word is added.
  CustomWordEntry({required this.onWordAdded});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(); // Controller for the text field

    return AlertDialog(
      title: Text('Add a new magnet'),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Enter text'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onWordAdded(controller.text); // Call the callback with the entered text
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
