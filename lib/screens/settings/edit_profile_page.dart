import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _musicController = TextEditingController();
  XFile? _profileImage;
  String? _selectedGender;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _noteController.dispose();
    _musicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save the profile changes
              print('Profile saved');
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!.path))
                      : AssetImage('assets/profile_image.jpg') as ImageProvider,
                  child: _profileImage == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 50.0,
                          color: Colors.grey[800],
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: _selectedGender,
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'User Note',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _musicController,
              decoration: InputDecoration(
                labelText: 'Music',
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
