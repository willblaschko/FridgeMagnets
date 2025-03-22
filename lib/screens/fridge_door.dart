import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/magnet.dart';
import '../models/magnet_model.dart';
import '../widgets/style_selection.dart';
import '../services/storage_service.dart';
import '../services/sound_service.dart';
import '../services/text_to_speech_service.dart';
import '../widgets/custom_word_entry.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FridgeDoor extends StatefulWidget {
  @override
  _FridgeDoorState createState() => _FridgeDoorState();
}

class _FridgeDoorState extends State<FridgeDoor> {
  List<MagnetModel> magnets = [];
  TextStyle selectedStyle = StyleSelection.DEFAULT_STYLE;
  final StorageService _storageService = StorageService();
  final SoundService _soundService = SoundService();
  final TextToSpeechService _textToSpeechService = TextToSpeechService();
  final ScreenshotController _screenshotController = ScreenshotController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDragging = false;
  bool _isOverTrashCan = false;
  bool _showStyleButtons = true;
  Color _foregroundColor = Colors.black;
  Color _backgroundColor = Colors.white;
  bool _isCustomStyleSelected = false;

  @override
  void initState() {
    super.initState();
    _loadMagnets();
  }

  void _addMagnet(String text) {
    // Sanitize input text
    String sanitizedText = text.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');
    List<String> words = sanitizedText.split(' ');
    Random random = Random();
    List<TextStyle> styles = StyleSelection.STYLES;
    setState(() {
      for (String word in words) {
        magnets.add(MagnetModel(
          text: word,
          style: _isCustomStyleSelected ? TextStyle(fontSize: 18, fontFamily: 'Roboto', color: _foregroundColor, backgroundColor: _backgroundColor) : styles[random.nextInt(styles.length)],
          position: Offset(100 + random.nextInt(20) - 10, 100 + random.nextInt(20) - 10),
          foregroundColor: _foregroundColor,
          backgroundColor: _backgroundColor,
        ));
      }
    });
    _saveMagnets();
  }

  void _updateMagnetPosition(MagnetModel magnet, Offset newPosition) {
    setState(() {
      magnet.position = newPosition;
    });
    _saveMagnets();
  }

  void _removeMagnet(MagnetModel magnet) {
    setState(() {
      magnets.remove(magnet);
    });
    _saveMagnets();
  }

  Future<void> _saveMagnets() async {
    await _storageService.saveMagnets(magnets);
  }

  Future<void> _loadMagnets() async {
    final loadedMagnets = await _storageService.loadMagnets();
    setState(() {
      magnets = loadedMagnets;
    });
  }

  Future<void> _shareMagnets() async {
    setState(() {
      _showStyleButtons = false;
    });
    await Future.delayed(Duration(milliseconds: 100)); // Wait for the UI to update
    magnets.sort((a, b) {
      if (a.position.dy == b.position.dy) {
        return a.position.dx.compareTo(b.position.dx);
      } else {
        return a.position.dy.compareTo(b.position.dy);
      }
    });
    StringBuffer magnetTexts = StringBuffer();
    for (int i = 0; i < magnets.length; i++) {
      if (i > 0 && (magnets[i].position.dy - magnets[i - 1].position.dy) > 50) {
        magnetTexts.write('\n');
      }
      magnetTexts.write(magnets[i].text + ' ');
    }
    final directory = (await getApplicationDocumentsDirectory()).path;
    final imagePath = '$directory/screenshot.png';
    try {
      Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes != null) {
        final File imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);
        Share.shareXFiles([XFile(imagePath)], text: magnetTexts.toString());
      }
    } catch (onError) {
      print(onError);
    }
    setState(() {
      _showStyleButtons = true;
    });
  }

  void _readPoetry() {
    _textToSpeechService.readPoetry(magnets);
  }

  void _confirmRemoveAllMagnets() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to remove all magnets?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  magnets.clear();
                });
                _saveMagnets();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Magnetic Poetry"),
        actions: [
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: _shareMagnets,
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: _readPoetry,
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: _confirmRemoveAllMagnets,
            ),
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/fridge_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            ...magnets.map((magnet) => Magnet(
                  magnet: magnet,
                  onDragEnd: (DraggableDetails details) {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    double appBarHeight = _scaffoldKey.currentState?.appBarMaxHeight ?? AppBar().preferredSize.height;
                    Offset localOffset = renderBox.globalToLocal(details.offset.translate(0, -appBarHeight));
                    if (_isOverTrashCan) {
                      _removeMagnet(magnet);
                      _isOverTrashCan = false;
                    } else {
                      _updateMagnetPosition(magnet, localOffset);
                    }
                    _soundService.playDropSound();
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  onDragStarted: () {
                    _soundService.playDragSound();
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onDragUpdate: (DragUpdateDetails details) {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    double appBarHeight = _scaffoldKey.currentState?.appBarMaxHeight ?? AppBar().preferredSize.height;
                    Offset localOffset = renderBox.globalToLocal(details.localPosition.translate(0, -appBarHeight));
                    setState(() {
                      _isOverTrashCan = localOffset.dx > MediaQuery.of(context).size.width - 100 && localOffset.dy < 100;
                    });
                  },
                )).toList(),
            if (_isDragging)
              Positioned(
                top: 20,
                right: 20,
                child: AnimatedOpacity(
                  opacity: _isOverTrashCan ? 1.0 : 0.5,
                  duration: Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    transform: _isOverTrashCan ? (Matrix4.identity()..scale(1.5)..translate(-12.5, -12.5)) : Matrix4.identity(),
                    child: Icon(
                      Icons.delete,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            if (_showStyleButtons)
              Positioned(
                bottom: 20,
                left: 20,
                child: StyleSelection(
                  selectedStyle: selectedStyle,
                  onStyleSelected: (style) {
                    setState(() {
                      selectedStyle = style;
                      _isCustomStyleSelected = false;
                    });
                  },
                  onCustomStyleSelected: (foregroundColor, backgroundColor) {
                    setState(() {
                      _foregroundColor = foregroundColor;
                      _backgroundColor = backgroundColor;
                      _isCustomStyleSelected = true;
                    });
                  },
                  isCustomStyleSelected: _isCustomStyleSelected,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomWordEntry(
                onWordAdded: (newText) {
                  _addMagnet(newText);
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
