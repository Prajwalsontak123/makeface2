import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

import 'anime_chat.dart'; // Import the AnimeChatScreen
import 'circle_screen.dart'; // Import the CircleScreen
import 'home_chat.dart'; // Import the HomeChatScreen
import 'profile_home.dart'; // Import the ProfileHome screen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MakeFace'),
        leading: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Add onPressed functionality for notifications
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add onPressed functionality for search
            },
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Navigate to HomeChatScreen when message icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeChatScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 100.0,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10, // Replace with actual number of stories
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundColor: index == 0
                              ? Colors.blue // Color for the first story
                              : const Color.fromARGB(255, 173, 175, 177),
                          child: index == 0
                              ? SizedBox.shrink()
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        if (index == 0)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Add the news feed
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 20, // Example number of posts
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'User $index',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Text('Caption for post $index'),
                      SizedBox(height: 10.0),
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        color: Colors.grey[300],
                        child: index % 2 == 0
                            ? Image.network(
                                'https://via.placeholder.com/200',
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  size: 50.0,
                                ),
                              ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.repeat),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, // Hide labels for selected item
        showUnselectedLabels: false, // Hide labels for unselected items
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        currentIndex: 0, // Set the current index to 0 (Home)
        onTap: (index) {
          // Navigate to the corresponding screen based on the tapped index
          switch (index) {
            case 0:
              // Navigate to HomeScreen
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
              // Handle navigation to Add Post
              _showAddPostOptions(context);
              break;
            case 4:
              // Navigate to ProfileHome
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

  // Function to open the camera
  void _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      // Handle the picked image
    }
  }

  // Function to open the device's local storage
  void _openLocalStorage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Handle the picked image
    }
  }
}
