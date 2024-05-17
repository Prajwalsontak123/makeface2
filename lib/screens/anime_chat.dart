import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'circle_screen.dart'; // Import the CircleScreen
import 'home_screen.dart'; // Import the HomeScreen
import 'profile_anime.dart'; // Import the ProfileAnime screen
import '../coscreens/anime_edit_profile.dart'; // Import the EditProfileScreen

class AnimeChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Chat'),
        actions: [
          IconButton(
            icon: Icon(
                Icons.edit), // Use the appropriate icon for editing profile
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stories Section (Similar to Instagram)
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
                            : const Color.fromARGB(
                                255, 173, 175, 177), // Color for other stories
                        child: index == 0
                            ? SizedBox
                                .shrink() // Empty container for the first story
                            : Text(
                                '${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ), // Number for other stories
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: index == 0
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileAnime()),
                                  );
                                },
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
                              )
                            : SizedBox.shrink(), // Spacer for other stories
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Chat Section (Similar to Snapchat)
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              children: [
                // Example chat messages
                buildChatMessage('User 1', 'Hey, how are you?'),
                buildChatMessage(
                    'User 2', 'I\'m doing great! Thanks for asking.'),
                buildChatMessage('User 1', 'Wanna hang out later?'),
                buildChatMessage('User 2', 'Sure, where do you want to meet?'),
                buildChatMessage('User 1', 'How about the park?'),
                buildChatMessage('User 2', 'Sounds good! See you there.'),
                // Add more chat messages as needed
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, // Hide labels for selected item
        showUnselectedLabels: false, // Hide labels for unselected items
        selectedIconTheme: IconThemeData(
            color: Colors.black), // Set the selected icon color to black
        unselectedIconTheme: IconThemeData(
            color: Colors.black), // Set the unselected icon color to black
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
              // Handle navigation to Incognito Mode (if needed)
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
              _showAddPostOptions(context);
              break;
            case 4:
              // Navigate to ProfileAnime
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileAnime()),
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
            icon: Icon(Icons.add), // Plus icon
            label: 'Add', // Label for plus icon
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profile icon
            label: 'Profile', // Label for profile icon
          ),
        ],
      ),
    );
  }

  Widget buildChatMessage(String sender, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(sender[0]), // Display first letter of sender's name
        ),
        title: Text(
          sender,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Icon(Icons.camera_alt), // Example camera icon for snaps
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
                  _getImageFromCamera(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Local Storage'),
                onTap: () {
                  _getImageFromGallery(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to get image from the camera
  void _getImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    // Do something with the picked image
    if (pickedImage != null) {
      // You can handle the picked image here
      // For example, you can display it in an Image widget
      // or upload it to a server
    }
  }

  // Function to get image from the gallery
  void _getImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    // Do something with the picked image
    if (pickedImage != null) {
      // You can handle the picked image here
      // For example, you can display it in an Image widget
      // or upload it to a server
    }
  }
}
