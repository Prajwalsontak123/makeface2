import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'your_story.dart';

class AfterCapture extends StatefulWidget {
  final String imagePath;

  const AfterCapture({Key? key, required this.imagePath}) : super(key: key);

  @override
  _AfterCaptureState createState() => _AfterCaptureState();
}

class _AfterCaptureState extends State<AfterCapture> {
  Color textColor = Colors.white;
  double fontSize = 20;
  List<Widget> addedElements = [];
  List<Offset> drawingPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  drawingPoints
                      .add(renderBox.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (details) {
                drawingPoints.add(Offset.infinite);
              },
              child: CustomPaint(
                painter: DrawingPainter(drawingPoints),
                child: Container(),
              ),
            ),
            ...addedElements,
            Column(
              children: [
                _buildTopBar(),
                Expanded(child: Container()),
                _buildBottomBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Spacer(),
          _buildIconButton(Icons.text_fields, 'Text', _showTextOptions),
          _buildIconButton(
              Icons.emoji_emotions_outlined, 'Stickers', _showStickerOptions),
          _buildIconButton(Icons.brush, 'Draw', () {}),
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildStoryButton('Your story'),
          SizedBox(width: 10),
          _buildStoryButton('Close Friends', isCloseFriends: true),
          Spacer(),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 24,
            child: Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryButton(String text, {bool isCloseFriends = false}) {
    return GestureDetector(
      onTap: () {
        if (text == 'Your story') {
          // Assume 'user123' is the unique name of the current user
          // In a real app, you would get this from your user authentication system
          YourStory.saveStory(context, widget.imagePath, 'user123');
        } else {
          // Handle 'Close Friends' option
          print('Close Friends story option selected');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (!isCloseFriends)
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[700],
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
            if (isCloseFriends) Icon(Icons.star, color: Colors.green, size: 16),
            SizedBox(width: 8),
            Text(text, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showTextOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: TextStyle(color: textColor, fontSize: fontSize),
                    decoration: InputDecoration(hintText: 'Enter text'),
                    onSubmitted: (value) {
                      setState(() {
                        addedElements.add(
                          Positioned(
                            left: 100,
                            top: 100,
                            child: Draggable(
                              feedback: Text(value,
                                  style: TextStyle(
                                      color: textColor, fontSize: fontSize)),
                              childWhenDragging: Container(),
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor, fontSize: fontSize)),
                            ),
                          ),
                        );
                      });
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Color'),
                  ColorPicker(
                    pickerColor: textColor,
                    onColorChanged: (color) {
                      setModalState(() {
                        textColor = color;
                      });
                    },
                    showLabel: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                  Text('Font Size'),
                  Slider(
                    value: fontSize,
                    min: 10,
                    max: 100,
                    onChanged: (value) {
                      setModalState(() {
                        fontSize = value;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showStickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildStickerOption('😀'),
              _buildStickerOption('🎉'),
              _buildStickerOption('❤️'),
              _buildStickerOption('🌟'),
              _buildStickerOption('🍕'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStickerOption(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          addedElements.add(
            Positioned(
              left: 150,
              top: 150,
              child: Draggable(
                feedback: Text(emoji, style: TextStyle(fontSize: 50)),
                childWhenDragging: Container(),
                child: Text(emoji, style: TextStyle(fontSize: 50)),
              ),
            ),
          );
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Text(emoji, style: TextStyle(fontSize: 50)),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
