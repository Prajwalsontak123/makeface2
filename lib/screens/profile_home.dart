import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'anime_chat.dart'; // Import the AnimeChatScreen
import 'circle_screen.dart'; // Import the CircleScreen
import 'home_screen.dart';

class ProfileHome extends StatefulWidget {
  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  late String _userName = ''; // Initialize _userName with an empty string
  late String _userId;
  late String _userBio = ''; // Initialize _userBio with an empty string

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Get the current user's ID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;

      // Access Firestore collection 'users' and document with user's ID
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_userId)
          .get();

      if (snapshot.exists) {
        // Get the user's name and bio from Firestore document data
        setState(() {
          _userName = snapshot.data()!['name'];
          _userBio = snapshot.data()!['bio'] ??
              ''; // If bio is null, use an empty string
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header Section
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      // You can add user's profile picture here
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to EditProfileScreen
                      },
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName, // Display user's name here
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      _userBio, // Display user's bio here
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        // You can add user's posts and followers count here
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1.5k',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Posts',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2.3m',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Followers',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2.0k',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'Following',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Profile Posts Section
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
              ),
              itemCount: 30, // Replace with actual number of posts
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, // Hide labels for selected item
        showUnselectedLabels: false, // Hide labels for unselected items
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        currentIndex: 4, // Set the current index to 4 (User Profile)
        onTap: (index) {
          // Navigate to the corresponding screen based on the tapped index
          switch (index) {
            case 0:
              // Navigate to HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              // Navigate to AnimeChatScreen when Incognito Mode icon is tapped
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AnimeChatScreen()),
              );
              break;
            case 2:
              // Navigate to CircleScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CircleScreen()),
              );
              break;
            case 3:
              // Handle navigation to Add Post (if needed)
              break;
            case 4:
              // Handle navigation to ProfileHomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileHome()),
              );
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
