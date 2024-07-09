import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class StoryCreationPage extends StatefulWidget {
  @override
  _StoryCreationPageState createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  CameraController? _cameraController;
  VideoPlayerController? _videoPlayerController;
  bool _isRecording = false;
  String _selectedMode = 'Normal';
  List<String> _cameraModes = [
    'Normal',
    'Boomerang',
    'Superzoom',
    'Rewind',
    'Hands-Free',
    'Create'
  ];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final cameras = await availableCameras();
        if (cameras.isEmpty) {
          setState(() {
            _errorMessage = 'No cameras found';
          });
          return;
        }
        final firstCamera = cameras.first;
        _cameraController = CameraController(
          firstCamera,
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        if (mounted) setState(() {});
      } else {
        setState(() {
          _errorMessage = 'Camera permission denied';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing camera: $e';
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.white),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(
                      _isRecording ? Icons.stop : Icons.fiber_manual_record,
                      color: Colors.white),
                  onPressed: () {
                    if (_isRecording) {
                      _stopVideoRecording();
                    } else {
                      _startVideoRecording();
                    }
                  },
                ),
                DropdownButton<String>(
                  value: _selectedMode,
                  dropdownColor: Colors.black54,
                  style: TextStyle(color: Colors.white),
                  items: _cameraModes.map((String mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMode = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle the selected image
      print('Image picked: ${image.path}');
    }
  }

  Future<void> _startVideoRecording() async {
    try {
      if (!_cameraController!.value.isRecordingVideo) {
        await _cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print('Error starting video recording: $e');
      // You can show an error message to the user here if needed
    }
  }

  Future<void> _stopVideoRecording() async {
    try {
      if (_cameraController!.value.isRecordingVideo) {
        final XFile videoFile = await _cameraController!.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });
        // Handle the recorded video
        print('Video saved to: ${videoFile.path}');
      }
    } catch (e) {
      print('Error stopping video recording: $e');
      // You can show an error message to the user here if needed
    }
  }
}
