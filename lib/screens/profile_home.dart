import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../coscreens/profile_home_edit.dart';
import 'anime_chat.dart';
import 'circle_screen.dart';
import 'home_screen.dart';

class ProfileHome extends StatefulWidget {
  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  late String _userName = '';
  late String _userId;
  late String _fetchedBio = '';
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

        // Fetch user data from loggedin_users collection based on email
        QuerySnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('loggedin_users')
                .where('email', isEqualTo: user.email)
                .limit(1)
                .get();

        if (userSnapshot.docs.isNotEmpty) {
          setState(() {
            _userName = userSnapshot.docs.first.data()['username'] ?? '';
            _fetchedBio = userSnapshot.docs.first.data()['bio'] ?? '';
          });
        }

        // Fetch user data from users collection
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_userId)
                .get();

        if (snapshot.exists) {
          setState(() {
            _profilePicUrl = snapshot.data()?['profilePicUrl'] ??
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
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileHomeEdit(_userId)),
              );
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(_profilePicUrl),
                                ),
                                SizedBox(height: 10.0),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileHomeEdit(_userId)),
                                    );
                                  },
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
                                      _buildStatColumn("Followers", "2.3m"),
                                      _buildStatColumn("Following", "2.0k"),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    _userName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 8.0),
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
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        currentIndex: 4,
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
              _showAddPostOptions(context);
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
            label: 'User Profile',
          ),
        ],
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
      child: Text(
        _fetchedBio,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildPostGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: GridView.builder(
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
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddPostOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Files'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add_a_photo),
                title: Text('Camera'),
                onTap: () {
                  _openCamera(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Local Storage'),
                onTap: () {
                  _openLocalStorage(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      // Handle the picked image
    }
  }

  void _openLocalStorage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Handle the picked image
    }
  }
}
