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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoryCreationPage(),
    );
  }
}

class StoryCreationPage extends StatefulWidget {
  @override
  _StoryCreationPageState createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isFilterApplied = false;
  XFile? _imageFile;
  List<Filter> filters = presetFiltersList;
  // ignore: unused_field
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

  Timer? _timer;
  int _recordingDuration = 0;

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
                  _drawingPoints,
                  _drawingColor,
                  _drawingThickness,
                ),
                size: Size.infinite,
              ),
              ..._stickers,
              Positioned(
                top: 10,
                left: 10,
                child: _isRecording ? _buildTimerDisplay() : SizedBox(),
              ),
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
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: _takePicture,
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
            _controlButton(Icons.fiber_manual_record, _toggleRecording),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Pause'),
              onPressed: _pauseVideoRecording,
            ),
            ElevatedButton(
              child: Text('Resume'),
              onPressed: _resumeVideoRecording,
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
    if (!_isRecording) {
      try {
        await _startVideoRecording();
      } on CameraException catch (e) {
        print('Error starting video recording: $e');
        setState(() {
          _isRecording = false;
        });
      }
    } else {
      try {
        await _stopVideoRecording();
      } on CameraException catch (e) {
        print('Error stopping video recording: $e');
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<void> _startVideoRecording() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isRecordingVideo) {
      return;
    }
    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _startTimer();
      });
    } on CameraException catch (e) {
      print('Error starting video recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_cameraController!.value.isRecordingVideo) {
      return;
    }
    try {
      await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _stopTimer();
        _resetTimer();
      });
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _pauseVideoRecording() async {
    if (!_cameraController!.value.isRecordingVideo || _isPaused) {
      return;
    }
    try {
      await _cameraController!.pauseVideoRecording();
      setState(() {
        _isPaused = true;
        _stopTimer();
      });
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> _resumeVideoRecording() async {
    if (!_cameraController!.value.isRecordingVideo || !_isPaused) {
      return;
    }
    try {
      await _cameraController!.resumeVideoRecording();
      setState(() {
        _isPaused = false;
        _startTimer();
      });
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isTakingPicture) {
      return;
    }
    try {
      XFile picture = await _cameraController!.takePicture();
      setState(() {
        _imageFile = picture;
        _isFilterApplied = false;
      });
    } on CameraException catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
        _isFilterApplied = false;
      });
    }
  }

  Future<void> _switchCamera() async {
    selectedCameraIdx = selectedCameraIdx == 0 ? 1 : 0;
    await _initializeCamera();
  }

  void _addTextOverlay() async {
    String? text = await _showTextInputDialog();
    if (text != null && text.isNotEmpty) {
      setState(() {
        _overlayText = text;
      });
    }
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
      _drawingPoints.clear();
    });
  }

  void _undoDrawing() {
    if (_undoStack.isNotEmpty) {
      setState(() {
        _redoStack.add(_undoStack.removeLast());
        _drawingPoints = _undoStack.isNotEmpty ? _undoStack.last : [];
      });
    }
  }

  void _redoDrawing() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _undoStack.add(_redoStack.removeLast());
        _drawingPoints = _undoStack.last;
      });
    }
  }

  void _addSticker() {
    setState(() {
      _stickers.add(
        Positioned(
          top: 100,
          left: 100,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _stickers.last = Positioned(
                  top: details.localPosition.dy,
                  left: details.localPosition.dx,
                  child: _stickers.last,
                );
              });
            },
            child: Icon(Icons.tag_faces, size: 50, color: Colors.yellow),
          ),
        ),
      );
    });
  }

  Future<void> _saveAndShare() async {
    RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/screenshot.png');
    await imgFile.writeAsBytes(pngBytes);

    await Share.shareXFiles([XFile(imgFile.path)], text: 'Check out my story!');
  }

  Future<String?> _showTextInputDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter text'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: 'Text'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_textController.text);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _recordingDuration = 0;
    });
  }

  Widget _buildTimerDisplay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        'Recording: ${_formatDuration(_recordingDuration)}',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  String _formatDuration(int duration) {
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawingPainter(this.points, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    for (int i = 0; i < points.length - 1; i++) {
      // ignore: unnecessary_null_comparison
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
