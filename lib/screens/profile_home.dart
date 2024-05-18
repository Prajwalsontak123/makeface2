import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../coscreens/profile_home_edit.dart';
import 'anime_chat.dart'; // Import your AnimeChat.dart file here
import 'circle_screen.dart'; // Import your CircleScreen.dart file here
import 'home_screen.dart'; // Import your HomeScreen.dart file here

class ProfileHome extends StatefulWidget {
  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  late String _userName = '';
  late String _userId;
  late String _userBio = '';
  late String _profilePicUrl = '';
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userId = user.uid;

        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_userId)
                .get();

        if (snapshot.exists) {
          setState(() {
            _userName = snapshot.data()?['username'] ?? '';
            _userBio = snapshot.data()?['bio'] ?? '';
            _profilePicUrl = snapshot.data()?['profile_image'] ??
                'https://via.placeholder.com/150';
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'User data not found.';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch user data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userName),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              var updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileHomeEdit(_userId)),
              );
              if (updatedData != null) {
                setState(() {
                  _userName = updatedData['username'];
                  _userBio = updatedData['bio'];
                  if (updatedData['profile_image'] != null) {
                    _profilePicUrl = updatedData['profile_image'];
                  }
                });
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage(_profilePicUrl),
                            ),
                            SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () async {
                                var updatedData = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileHomeEdit(_userId)),
                                );
                                if (updatedData != null) {
                                  setState(() {
                                    _userName = updatedData['username'];
                                    _userBio = updatedData['bio'];
                                    if (updatedData['profile_image'] != null) {
                                      _profilePicUrl =
                                          updatedData['profile_image'];
                                    }
                                  });
                                }
                              },
                              child: Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _userName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _userBio,
                        style: TextStyle(fontSize: 16),
                      ),
                      // Add other profile details as needed
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Set the current index to 4 (Profile)
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AnimeChatScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CircleScreen()),
              );
              break;
            case 3:
              // Handle navigation to Add Post
              // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
              break;
            case 4:
              // Do nothing, already on the profile screen
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
            label: 'User Profile',
          ),
        ],
      ),
    );
  }
}
