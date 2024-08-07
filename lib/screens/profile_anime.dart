import 'package:flutter/material.dart';
import 'package:makeface2/screens/anime_chat.dart';

import '../coscreens/anime_edit_profile.dart'; // Import the EditProfileScreen
import 'circle_screen.dart'; // Import the CircleScreen
import 'home_screen.dart'; // Import the HomeScreen
import 'bottom_nav_bar.dart'; // Import the BottomNavBar widget

class ProfileAnime extends StatefulWidget {
  @override
  _ProfileAnimeState createState() => _ProfileAnimeState();
}

class _ProfileAnimeState extends State<ProfileAnime> {
  String _imagePath = 'assets/profile_image.png'; // Default image path

  void _selectImage() {
    // Add logic to select an image from gallery or camera
    setState(() {
      // Update the image path with the selected image
      _imagePath = 'assets/selected_image.png'; // Replace with actual image path
    });
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
              MaterialPageRoute(builder: (context) => AnimeChatScreen()),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20.0),
          // Row to display avatar, name, and biography
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // Align children to the start
            children: <Widget>[
              // Add spacing around the rectangular avatar
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 20.0), // Adjust left padding here
                child: GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    width: 160,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue, // You can replace this with your background image
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(_imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Vertical space between avatar and name/biography
              SizedBox(width: 20.0),
              // Column to display name and biography
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'New York, USA',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to EditProfileScreen when "Edit Profile" is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
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
              // Navigate to AnimeChatScreen
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
              // Stay on ProfileAnime screen
              break;
          }
        },
      ),
    );
  }
}
