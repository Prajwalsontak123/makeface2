import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'aftercapture.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isCameraInitialized = false;
  bool isRearCamera = true;
  bool isFlashOn = false;
  String currentMode = 'Photo';

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    controller =
        CameraController(cameras[isRearCamera ? 0 : 1], ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> toggleCamera() async {
    isRearCamera = !isRearCamera;
    await controller.dispose();
    controller =
        CameraController(cameras[isRearCamera ? 0 : 1], ResolutionPreset.high);
    await controller.initialize();
    setState(() {});
  }

  Future<void> toggleFlash() async {
    if (controller.value.flashMode == FlashMode.off) {
      await controller.setFlashMode(FlashMode.torch);
      isFlashOn = true;
    } else {
      await controller.setFlashMode(FlashMode.off);
      isFlashOn = false;
    }
    setState(() {});
  }

  Future<void> captureImage() async {
    try {
      final image = await controller.takePicture();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AfterCapture(imagePath: image.path),
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  void switchToCreateMode() {
    setState(() {
      currentMode = 'Create';
    });
    // Add text overlay functionality here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Mode'),
          content: Text('Add text overlay functionality here.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void switchToBoomerangMode() {
    setState(() {
      currentMode = 'Boomerang';
    });
    // Implement boomerang functionality here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Boomerang Mode'),
          content: Text('Implement boomerang capture functionality here.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void switchToLayoutMode() {
    setState(() {
      currentMode = 'Layout';
    });
    // Implement layout selection functionality here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Layout Mode'),
          content: Text('Implement layout selection functionality here.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          isCameraInitialized
              ? CameraPreview(controller)
              : Container(color: Colors.black),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFlashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: toggleFlash,
                        ),
                        SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.settings,
                              color: Colors.white, size: 28),
                          onPressed: () {
                            // Add settings functionality here
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSidebarOption(Icons.text_fields, "Create",
                    color: Colors.blue, onTap: switchToCreateMode),
                _buildSidebarOption(Icons.loop, "Boomerang",
                    color: Colors.red, onTap: switchToBoomerangMode),
                _buildSidebarOption(Icons.grid_on, "Layout",
                    color: Colors.green, onTap: switchToLayoutMode),
                _buildSidebarOption(Icons.radio_button_checked, "Hands-free",
                    color: Colors.yellow),
                IconButton(
                  icon: Icon(Icons.switch_camera, color: Colors.white),
                  onPressed: toggleCamera,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomNavItem("Post", color: Colors.grey),
                    _buildBottomNavItem("Story",
                        isActive: true, color: Colors.blue),
                    _buildBottomNavItem("Reel", color: Colors.red),
                    _buildBottomNavItem("Live", color: Colors.green),
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: captureImage,
                  child: _buildCaptureButton(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                currentMode,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarOption(IconData icon, String label,
      {Color color = Colors.white, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(String label,
      {bool isActive = false, Color color = Colors.white}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive ? color : Colors.white54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        if (isActive)
          Container(
            margin: EdgeInsets.only(top: 4),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
      ],
    );
  }

  Widget _buildCaptureButton() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.camera, color: Colors.white, size: 40),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CameraScreen(),
    theme: ThemeData.dark(),
  ));
}
