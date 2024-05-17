import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
// Import dart:io to access Platform files
import 'anime_chat.dart'; // Import the AnimeChatScreen
import 'home_screen.dart';
import 'circle_profile.dart'; // Import the CircleProfile

class CircleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Circles'),
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
                  // Add onPressed functionality for chat
                },
              ),
            ],
            floating: true,
            snap: true,
            elevation: 0,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10, // Total number of stories
                itemBuilder: (BuildContext context, int index) {
                  if (index < 5) {
                    // Display the first 5 stories horizontally
                    return Container(
                      width: 72.0,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    // Return an empty container for the rest of the stories
                    return SizedBox(width: 0);
                  }
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50.0,
              color: Colors.grey[300],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(15, (index) {
                    return Container(
                      width: 50.0,
                      height: 50.0,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          '${index + 6}', // Starting from 6th story
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'User $index', // Example username
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Text('Caption for post $index'), // Example caption
                      SizedBox(height: 10.0),
                      // Example image or video
                      // You can replace this with the actual post content
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        color: Colors.grey[300], // Placeholder for post content
                        // You can replace this with the actual post content
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
                            onPressed: () {
                              // Add onPressed functionality for like
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              // Add onPressed functionality for comment
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              // Add onPressed functionality for share
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.repeat),
                            onPressed: () {
                              // Add onPressed functionality for repost
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: 20, // Example number of posts
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, // Hide labels for selected item
        showUnselectedLabels: false, // Hide labels for unselected items
        selectedIconTheme: IconThemeData(
          color: Colors.black,
        ), // Set the selected icon color to black
        unselectedIconTheme: IconThemeData(
          color: Colors.black,
        ), // Set the unselected icon color to black
        currentIndex: 2, // Set the current index to 2 (Circle)
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
              // Do nothing, already in CircleScreen
              break;
            case 3:
              // Show dialog box when "Add Post" icon is tapped
              _showAddPostOptions(context);
              break;
            case 4:
              // Navigate to circle_profile.dart
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CircleProfile()),
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
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Local Storage'),
                onTap: () {
                  _openGallery(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    Navigator.pop(context); // Close the dialog
    // Handle the picked file as needed
    if (pickedFile != null) {
      // Do something with the picked image
    }
  }

  void _openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    Navigator.pop(context); // Close the dialog
    // Handle the picked file as needed
    if (pickedFile != null) {
      // Do something with the picked image
    }
  }
}
