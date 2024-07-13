import 'dart:io';

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
  XFile? _mediaFile;
  bool _isVideo = false;
  bool _isRecording = false;
  TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.photos.request();

    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;
    final image = await _cameraController!.takePicture();
    setState(() {
      _mediaFile = image;
      _isVideo = false;
    });
  }

  Future<void> _startVideoRecording() async {
    if (!_cameraController!.value.isInitialized) return;
    await _cameraController!.startVideoRecording();
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopVideoRecording() async {
    if (!_cameraController!.value.isRecordingVideo) return;
    final video = await _cameraController!.stopVideoRecording();
    setState(() {
      _mediaFile = video;
      _isVideo = true;
      _isRecording = false;
    });
    _initializeVideoPlayer();
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Media'),
        actions: [
          TextButton(
            child: Text('Image'),
            onPressed: () async {
              Navigator.of(context)
                  .pop(await picker.pickImage(source: ImageSource.gallery));
            },
          ),
          TextButton(
            child: Text('Video'),
            onPressed: () async {
              Navigator.of(context)
                  .pop(await picker.pickVideo(source: ImageSource.gallery));
            },
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _mediaFile = pickedFile;
        _isVideo = pickedFile.name.toLowerCase().endsWith('.mp4');
      });
      if (_isVideo) {
        _initializeVideoPlayer();
      }
    }
  }

  void _initializeVideoPlayer() {
    if (_mediaFile != null) {
      _videoPlayerController =
          VideoPlayerController.file(File(_mediaFile!.path))
            ..initialize().then((_) {
              setState(() {});
              _videoPlayerController!.play();
            });
    }
  }

  void _applyFilter() {
    // Implement filter logic
  }

  void _post() {
    // Implement posting logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Story'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _post,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_mediaFile == null)
              _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Center(child: CircularProgressIndicator())
            else
              _isVideo
                  ? _videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController!),
                        )
                      : Center(child: CircularProgressIndicator())
                  : Image.file(File(_mediaFile!.path)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _takePicture,
                ),
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.videocam),
                  onPressed:
                      _isRecording ? _stopVideoRecording : _startVideoRecording,
                ),
                IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: _pickMedia,
                ),
              ],
            ),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(hintText: 'Write a caption...'),
            ),
            // Add other buttons and logic as required...
          ],
        ),
      ),
    );
  }
}
