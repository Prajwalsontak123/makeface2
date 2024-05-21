import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHomeEdit extends StatefulWidget {
  final String userId;

  ProfileHomeEdit(this.userId);

  @override
  _ProfileHomeEditState createState() => _ProfileHomeEditState();
}

class _ProfileHomeEditState extends State<ProfileHomeEdit> {
  final TextEditingController _user_IDController =
      TextEditingController(); // Updated controller name
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('loggedin_users')
          .doc(widget.userId)
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _user_IDController.text =
            data['user_ID'] ?? ''; // Updated field name here
        _usernameController.text = data['username'] ?? '';
        _bioController.text = data['bio'] ?? '';
      });
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile;
    });
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String? downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async {
    try {
      String? imageUrl;
      if (_profileImage != null) {
        imageUrl = await _uploadImage(_profileImage!);
      }

      Map<String, dynamic> updatedData = {
        'user_ID': _user_IDController.text, // Updated field name here
        'username': _usernameController.text,
        'bio': _bioController.text,
      };

      if (imageUrl != null) {
        updatedData['profile_image'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('loggedin_users')
          .doc(widget.userId)
          .update(updatedData);

      print("Profile updated successfully");
      Navigator.pop(context, updatedData);
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _user_IDController, // Updated controller name here
              decoration: InputDecoration(
                labelText: 'User ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
