import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/profile_anime.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  String _profileImagePath = 'assets/profile_image.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveProfileChanges,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _selectProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImagePath.contains('assets')
                      ? AssetImage(_profileImagePath)
                      : FileImage(File(_profileImagePath)) as ImageProvider,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: TextButton(
                onPressed: _selectProfileImage,
                child: Text('Change Profile Picture'),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(
          color: Colors.black,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.black,
        ),
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileAnime()),
              );
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_reaction_outlined),
            label: 'Incognito Mode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trip_origin_outlined),
            label: 'Circle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _saveProfileChanges() {
    Navigator.pop(context);
  }

  void _selectProfileImage() async {
    final pickedImage = await _showImagePickerDialog();
    if (pickedImage != null) {
      setState(() {
        _profileImagePath = pickedImage.path;
      });
    }
  }

  Future<XFile?> _showImagePickerDialog() async {
    return showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pick from gallery'),
                  onTap: () async {
                    final pickedImage = await _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop(pickedImage);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Take a photo'),
                  onTap: () async {
                    final pickedImage = await _pickImage(ImageSource.camera);
                    Navigator.of(context).pop(pickedImage);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    return await ImagePicker().pickImage(source: source);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
