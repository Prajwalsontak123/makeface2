import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';
import 'package:share_plus/share_plus.dart';

class StoryCreationPage extends StatefulWidget {
  @override
  _StoryCreationPageState createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isFilterApplied = false;
  XFile? _imageFile;
  List<Filter> filters = presetFiltersList;
  imageLib.Image? _filteredImage;
  File? _filteredImageFile;
  List<CameraDescription>? cameras;
  int selectedCameraIdx = 0;
  TextEditingController _textController = TextEditingController();
  String _overlayText = '';
  Offset _textPosition = Offset(20, 50);
  bool _isDrawing = false;
  Color _drawingColor = Colors.red;
  double _drawingThickness = 5.0;
  List<Offset> _drawingPoints = [];
  List<List<Offset>> _undoStack = [];
  List<List<Offset>> _redoStack = [];
  List<Widget> _stickers = [];
  GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isEmpty) {
      return;
    }
    _cameraController =
        CameraController(cameras![selectedCameraIdx], ResolutionPreset.high);
    try {
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: RepaintBoundary(
        key: _repaintBoundaryKey,
        child: GestureDetector(
          onPanUpdate: _isDrawing ? _onPanUpdate : null,
          onPanEnd: _isDrawing ? _onPanEnd : null,
          child: Stack(
            children: [
              CameraPreview(_cameraController!),
              if (_isFilterApplied && _filteredImageFile != null)
                Image.file(_filteredImageFile!),
              if (_overlayText.isNotEmpty)
                Positioned(
                  top: _textPosition.dy,
                  left: _textPosition.dx,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _textPosition += details.delta;
                      });
                    },
                    child: Text(
                      _overlayText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              CustomPaint(
                painter: DrawingPainter(
                    _drawingPoints, _drawingColor, _drawingThickness),
                size: Size.infinite,
              ),
              ..._stickers,
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildControls(),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _controlButton(Icons.flash_on, _toggleFlash),
            _controlButton(Icons.filter, _applyFilter),
            _controlButton(
                _isRecording ? Icons.stop : Icons.fiber_manual_record,
                _toggleRecording),
            _controlButton(Icons.image, _pickImage),
            _controlButton(Icons.switch_camera, _switchCamera),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Text'),
              onPressed: _addTextOverlay,
            ),
            ElevatedButton(
              child: Text('Draw'),
              onPressed: _toggleDrawingMode,
            ),
            ElevatedButton(
              child: Text('Undo'),
              onPressed: _undoDrawing,
            ),
            ElevatedButton(
              child: Text('Redo'),
              onPressed: _redoDrawing,
            ),
            ElevatedButton(
              child: Text('Stickers'),
              onPressed: _addSticker,
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorPickerButton(Colors.red),
            _colorPickerButton(Colors.blue),
            _colorPickerButton(Colors.green),
            _colorPickerButton(Colors.yellow),
            _colorPickerButton(Colors.black),
            Slider(
              value: _drawingThickness,
              min: 1.0,
              max: 10.0,
              onChanged: (value) {
                setState(() {
                  _drawingThickness = value;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text('Save & Share'),
          onPressed: _saveAndShare,
        ),
      ],
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _colorPickerButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _drawingColor = color;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  void _toggleFlash() {
    if (_cameraController!.value.flashMode == FlashMode.off) {
      _cameraController!.setFlashMode(FlashMode.torch);
    } else {
      _cameraController!.setFlashMode(FlashMode.off);
    }
  }

  Future<void> _applyFilter() async {
    if (_imageFile == null) {
      return;
    }
    var image = imageLib.decodeImage(await _imageFile!.readAsBytes());
    image = imageLib.copyResize(image!, width: 600);
    String filename = path.basename(_imageFile!.path);
    Map imagefile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: Text("Apply Filter"),
          image: image!,
          filters: presetFiltersList,
          filename: filename,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.cover,
        ),
      ),
    );
    // ignore: unnecessary_null_comparison
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        _filteredImage = imagefile['image_filtered'];
        _filteredImageFile = File(imagefile['image_filtered_path']);
        _isFilterApplied = true;
      });
    }
  }

  Future<void> _toggleRecording() async {
    setState(() {
      _isRecording = !_isRecording;
    });
    if (_isRecording) {
      await _cameraController!.startVideoRecording();
    } else {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      print('Video saved to: ${videoFile.path}');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
        _isFilterApplied = false;
      });
    }
  }

  void _switchCamera() async {
    selectedCameraIdx = selectedCameraIdx == 0 ? 1 : 0;
    await _cameraController?.dispose();
    _initializeCamera();
  }

  void _addTextOverlay() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Text Overlay'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: "Enter text"),
            onChanged: (value) {
              setState(() {
                _overlayText = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _toggleDrawingMode() {
    setState(() {
      _isDrawing = !_isDrawing;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _drawingPoints.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _undoStack.add(List.from(_drawingPoints));
      _drawingPoints.add(Offset.zero);
    });
  }

  void _undoDrawing() {
    if (_undoStack.isNotEmpty) {
      setState(() {
        _redoStack.add(_undoStack.removeLast());
        if (_undoStack.isNotEmpty) {
          _drawingPoints = _undoStack.last;
        } else {
          _drawingPoints = [];
        }
      });
    }
  }

  void _redoDrawing() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _drawingPoints = _redoStack.removeLast();
        _undoStack.add(List.from(_drawingPoints));
      });
    }
  }

  void _addSticker() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? stickerImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (stickerImage != null) {
      setState(() {
        _stickers.add(
          Positioned(
            top: 100,
            left: 100,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  Offset stickerPosition = Offset(
                      details.localPosition.dx, details.localPosition.dy);
                  _stickers.removeLast();
                  _stickers.add(Positioned(
                    top: stickerPosition.dy,
                    left: stickerPosition.dx,
                    child: Image.file(File(stickerImage.path),
                        width: 100, height: 100),
                  ));
                });
              },
              child:
                  Image.file(File(stickerImage.path), width: 100, height: 100),
            ),
          ),
        );
      });
    }
  }

  void _saveAndShare() async {
    RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Save the image to a file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String fullPath = path.join(dir, 'story.png');
    File file = File(fullPath);
    await file.writeAsBytes(pngBytes);

    // Share the image
    await Share.shareXFiles([XFile(fullPath)], text: 'Check out my story!');
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double thickness;

  DrawingPainter(this.points, this.color, this.thickness);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.thickness != thickness;
  }
}
