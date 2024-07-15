import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

class StoryCreationPage extends StatefulWidget {
  @override
  _StoryCreationPageState createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  CameraDescription? selectedCamera;
  bool _isFrontCamera = false;
  FlashMode _flashMode = FlashMode.off;
  double _zoomLevel = 1.0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    selectedCamera = cameras!.first;

    _controller = CameraController(selectedCamera!, ResolutionPreset.high);
    await _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void switchCamera() async {
    if (cameras == null || cameras!.isEmpty) return;

    _isFrontCamera = !_isFrontCamera;
    selectedCamera = _isFrontCamera ? cameras![1] : cameras![0];

    _controller = CameraController(selectedCamera!, ResolutionPreset.high);
    await _controller!.initialize();
    setState(() {});
  }

  void toggleFlash() {
    _flashMode = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    _controller?.setFlashMode(_flashMode);
    setState(() {});
  }

  Future<void> startVideoRecording() async {
    if (_controller!.value.isRecordingVideo) return;

    try {
      await _controller!.startVideoRecording();
      print('Video recording started');
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> stopVideoRecording() async {
    if (!_controller!.value.isRecordingVideo) return;

    try {
      final videoFile = await _controller!.stopVideoRecording();
      print('Video recorded: ${videoFile.path}');
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  void applyFilter() {
    print("Filter applied");
  }

  void addTextOverlay() {
    print("Text overlay added");
  }

  void addSticker() {
    print("Sticker added");
  }

  void addAREffect() {
    print("AR effect applied");
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        print("Photo mode selected");
        break;
      case 1:
        print("Video mode selected");
        startVideoRecording();
        break;
      case 2:
        print("Story mode selected");
        break;
      case 3:
        print("Reels mode selected");
        break;
      case 4:
        print("Live mode selected");
        break;
    }
  }

  Future<List<Medium>> fetchRecentPhotos() async {
    List<Album> albums =
        await PhotoGallery.listAlbums(mediumType: MediumType.image);
    if (albums.isNotEmpty) {
      Album album = albums.first;
      MediaPage mediaPage = await album.listMedia();
      return mediaPage.items;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_selectedIndex == 0)
            FutureBuilder<List<Medium>>(
              future: fetchRecentPhotos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching photos'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No photos found'));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Medium medium = snapshot.data![index];
                    return FutureBuilder<Uint8List?>(
                      future: medium.getThumbnail(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Center(child: Text('Error loading thumbnail'));
                        }
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      },
                    );
                  },
                );
              },
            )
          else
            CameraPreview(_controller!),
          _buildCaptureButton(),
          _buildGalleryAccessButton(),
          _buildOtherControls(),
          _buildZoomSlider(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Story',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Live',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onItemTapped,
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (_selectedIndex == 1) {
                if (_controller!.value.isRecordingVideo) {
                  await stopVideoRecording();
                } else {
                  await startVideoRecording();
                }
              } else {
                try {
                  final image = await _controller!.takePicture();
                  print('Image captured: ${image.path}');
                } catch (e) {
                  print(e);
                }
              }
            },
            child: Icon(
              _selectedIndex == 1 && _controller!.value.isRecordingVideo
                  ? Icons.stop
                  : Icons.camera,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryAccessButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: IconButton(
        icon: Icon(Icons.photo_library),
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            print('Image selected: ${pickedFile.path}');
          }
        },
      ),
    );
  }

  Widget _buildOtherControls() {
    return Positioned(
      top: 40,
      left: 20,
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: switchCamera,
          ),
          IconButton(
            icon: Icon(
                _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on),
            onPressed: toggleFlash,
          ),
          IconButton(
            icon: Icon(Icons.filter),
            onPressed: applyFilter,
          ),
          IconButton(
            icon: Icon(Icons.text_fields),
            onPressed: addTextOverlay,
          ),
          IconButton(
            icon: Icon(Icons.emoji_emotions),
            onPressed: addSticker,
          ),
          IconButton(
            icon: Icon(Icons.face),
            onPressed: addAREffect,
          ),
        ],
      ),
    );
  }

  Widget _buildZoomSlider() {
    return Positioned(
      bottom: 150,
      right: 10,
      child: Column(
        children: [
          Icon(Icons.zoom_in),
          RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: _zoomLevel,
              min: 1.0,
              max: 8.0,
              onChanged: (value) {
                setState(() {
                  _zoomLevel = value;
                  _controller?.setZoomLevel(_zoomLevel);
                });
              },
            ),
          ),
          Icon(Icons.zoom_out),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StoryCreationPage(),
  ));
}
