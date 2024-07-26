import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makeface2/screens/view_notification.dart';

import '../coscreens/profile_home_edit.dart';
import 'anime_chat.dart';
import 'bottom_nav_bar.dart';
import 'circle_screen.dart';
import 'fans_list.dart'; // Import the fans list screen
import 'home_screen.dart';
// Import the NotificationScreen
import 'settings_page.dart';
import 'supporter_list.dart'; // Import the supporter list screen

class ProfileHome extends StatefulWidget {
  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  late String _uniqueName = '';
  late String _userName = '';
  late String _userId;
  late String _fetchedBio = '';
  late String _profileImageUrl = '';
  late String _fansCount = '0';
  late String _supportingCount = '0';
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

        // Fetch user data from loggedin_users collection based on user ID
        DocumentReference<Map<String, dynamic>> userDocRef = FirebaseFirestore
            .instance
            .collection('loggedin_users')
            .doc(user.uid);
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await userDocRef.get();

        if (userSnapshot.exists) {
          final data = userSnapshot.data() ?? {};

          if (data['fans'] == null) {
            await userDocRef.update({'fans': []});
          }
          if (data['supporting'] == null) {
            await userDocRef.update({'supporting': []});
          }

          // Fetch user data again after ensuring fields exist
          DocumentSnapshot<Map<String, dynamic>> updatedUserSnapshot =
              await userDocRef.get();
          final updatedData = updatedUserSnapshot.data() ?? {};

          setState(() {
            _uniqueName = updatedData['unique_name'] ?? '';
            _userName = updatedData['username'] ?? '';
            _fetchedBio = updatedData['bio'] ?? '';
            _profileImageUrl = updatedData['profile_image'] ?? '';

            // Check if 'fans' and 'supporting' fields exist and get their counts
            _fansCount =
                (updatedData['fans'] as List<dynamic>?)?.length.toString() ??
                    '0';
            _supportingCount = (updatedData['supporting'] as List<dynamic>?)
                    ?.length
                    .toString() ??
                '0';
          });
        } else {
          setState(() {
            _errorMessage = 'User data not found.';
          });
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'User not logged in.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch user data: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToEditProfile() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileHomeEdit(_userId)),
    );

    if (updatedData != null) {
      setState(() {
        _uniqueName = updatedData['unique_name'] ?? _uniqueName;
        _userName = updatedData['username'] ?? _userName;
        _fetchedBio = updatedData['bio'] ?? _fetchedBio;
        _profileImageUrl = updatedData['profile_image'] ?? _profileImageUrl;
      });
    }
  }

  void _navigateToSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  void _navigateToNotificationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewNotificationPage()),
    );
  }

  void _navigateToFansList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FansList()),
    );
  }

  void _navigateToSupporterList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SupporterList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_uniqueName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: _navigateToNotificationScreen,
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: _navigateToSettingsPage,
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: _profileImageUrl.isNotEmpty
                                      ? NetworkImage(_profileImageUrl)
                                      : AssetImage('assets/images/avatar.png')
                                          as ImageProvider,
                                ),
                                SizedBox(height: 10.0),
                                ElevatedButton(
                                  onPressed: _navigateToEditProfile,
                                  child: Text('Edit Profile'),
                                ),
                              ],
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildStatColumn("Posts", "20"),
                                      GestureDetector(
                                        onTap: _navigateToFansList,
                                        child: _buildStatColumn("Fans", _fansCount),
                                      ),
                                      GestureDetector(
                                        onTap: _navigateToSupporterList,
                                        child: _buildStatColumn(
                                            "Supporting", _supportingCount),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  _buildBioSection(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      _buildPostGrid(),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: (index) {
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
              _showAddPostOptions(context);
              break;
            case 4:
              // Stay on ProfileHome screen
              break;
          }
        },
      ),
    );
  }

  Column _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username: $_userName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            _fetchedBio,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPostGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemCount: 30,
      itemBuilder: (BuildContext context, int index) {
        return Image.network(
          'https://via.placeholder.com/150',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/avatar.png', fit: BoxFit.cover);
          },
        );
      },
    );
  }

  void _showAddPostOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Post'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickImage();
              },
              child: Text('Add Photo'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickVideo();
              },
              child: Text('Add Video'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Handle the picked image file
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Handle the picked video file
    }
  }
}
