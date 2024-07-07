import 'package:flutter/material.dart';
import 'dart:math';
import '../models/magnet_model.dart';

/// A widget representing a draggable magnet on the fridge door.
class Magnet extends StatefulWidget {
  final MagnetModel magnet; // The model representing the magnet
  final Function(DraggableDetails) onDragEnd; // Callback for when dragging ends
  final Function() onDragStarted; // Callback for when dragging starts
  final Function(DragUpdateDetails) onDragUpdate; // Callback for when dragging updates

  /// Constructor for creating a [Magnet] widget.
  ///
  /// [magnet] is the model representing the magnet.
  /// [onDragStarted] is the callback for when dragging starts.
  /// [onDragEnd] is the callback for when dragging ends.
  /// [onDragUpdate] is the callback for when dragging updates.
  Magnet({required this.magnet, required this.onDragStarted, required this.onDragEnd, required this.onDragUpdate});

  @override
  _MagnetState createState() => _MagnetState();
}

class _MagnetState extends State<Magnet> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Animation controller for magnet animation
  late Animation<Offset> _animation; // Animation for magnet movement
  late double _randomAngle; // Random angle for magnet rotation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    _controller.forward();
    _randomAngle = (Random().nextDouble() * 30 - 15) * pi / 180; // Generate a random angle between -15 and 15 degrees
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.magnet.position.dx,
      top: widget.magnet.position.dy,
      child: Transform.rotate(
        angle: _randomAngle,
        child: Draggable(
          feedback: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.magnet.style.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                widget.magnet.text,
                style: widget.magnet.style,
              ),
            ),
          ),
          childWhenDragging: Container(),
          onDragStarted: (){
            widget.onDragStarted();
          },
          onDragEnd: (details) {
            widget.onDragEnd(details);
          },
          onDragUpdate: (details){
            widget.onDragUpdate(details);
          },
          child: SlideTransition(
            position: _animation,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.magnet.style.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                widget.magnet.text,
                style: widget.magnet.style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
