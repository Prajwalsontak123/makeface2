import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:makeface2/screens/home_screen.dart';
import 'package:uuid/uuid.dart';

class YourStory {
  static Future<void> saveStory(BuildContext context, String imagePath,
      [String? s]) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Get the user's unique name from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('loggedin_users')
              .doc(user.uid)
              .get();

      if (!userSnapshot.exists) {
        throw Exception('User data not found');
      }

      String uniqueName = userSnapshot.data()?['unique_name'] ?? '';
      if (uniqueName.isEmpty) {
        throw Exception('Unique name not found');
      }

      // Generate a unique filename
      final String fileName = '${Uuid().v4()}.jpg';

      // Upload the file to Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('stories/$uniqueName/$fileName');
      await storageRef.putFile(File(imagePath));

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Story saved and uploaded successfully!')),
      );

      // Navigate back to HomeScreen after saving
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print('Error saving story: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save story. Please try again.')),
      );
    }
  }
}
