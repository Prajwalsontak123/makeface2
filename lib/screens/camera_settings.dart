import 'package:flutter/material.dart';
import 'package:makeface2/screens/storysettings.dart';

void main() {
  runApp(CameraSettingsApp());
}

class CameraSettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraSettingsScreen(),
    );
  }
}

class CameraSettingsScreen extends StatefulWidget {
  @override
  _CameraSettingsScreenState createState() => _CameraSettingsScreenState();
}

class _CameraSettingsScreenState extends State<CameraSettingsScreen> {
  bool alwaysStartOnFrontCamera = false;
  bool allowAccess = false;
  String cameraToolbarSide = "Left side";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Settings"),
        actions: [
          TextButton(
            onPressed: () {
              // Handle done action
            },
            child: Text(
              "Done",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Story"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StorySettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.video_camera_front),
            title: Text("Reels"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Reels settings
            },
          ),
          ListTile(
            leading: Icon(Icons.live_tv),
            title: Text("Live"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle Live settings
            },
          ),
          Divider(),
          SwitchListTile(
            title: Text("Always start on front camera"),
            value: alwaysStartOnFrontCamera,
            onChanged: (bool value) {
              setState(() {
                alwaysStartOnFrontCamera = value;
              });
            },
          ),
          Divider(),
          ListTile(
            title: Text("Camera tools"),
            subtitle: Text(
              "Choose which side of the screen you want your camera toolbar to be on.",
              style: TextStyle(fontSize: 12),
            ),
          ),
          RadioListTile<String>(
            title: Text("Left side"),
            value: "Left side",
            groupValue: cameraToolbarSide,
            onChanged: (String? value) {
              setState(() {
                cameraToolbarSide = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text("Right side"),
            value: "Right side",
            groupValue: cameraToolbarSide,
            onChanged: (String? value) {
              setState(() {
                cameraToolbarSide = value!;
              });
            },
          ),
          Divider(),
          SwitchListTile(
            title: Text("Allow access"),
            subtitle: Text(
              "Allow Instagram to suggest stories and posts and prepare ready-made reels from photos and videos on your device camera roll using data like image quality, location, and the presence of people or animals.",
              style: TextStyle(fontSize: 12),
            ),
            value: allowAccess,
            onChanged: (bool value) {
              setState(() {
                allowAccess = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
