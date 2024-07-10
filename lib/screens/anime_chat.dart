import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'circle_screen.dart';
import 'home_screen.dart';
import 'profile_anime.dart';
import '../coscreens/anime_edit_profile.dart';
import 'bottom_nav_bar.dart';

class AnimeChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
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
          Container(
            height: 100.0,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundColor: index == 0
                            ? Colors.blue
                            : const Color.fromARGB(255, 173, 175, 177),
                        child: index == 0
                            ? SizedBox.shrink()
                            : Text(
                                '${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
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
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              children: [
                buildChatMessage('User 1', 'Hey, how are you?'),
                buildChatMessage('User 2', 'I\'m doing great! Thanks for asking.'),
                buildChatMessage('User 1', 'Wanna hang out later?'),
                buildChatMessage('User 2', 'Sure, where do you want to meet?'),
                buildChatMessage('User 1', 'How about the park?'),
                buildChatMessage('User 2', 'Sounds good! See you there.'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              // Handle navigation to Incognito Mode (if needed)
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileAnime()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget buildChatMessage(String sender, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(sender[0]),
        ),
        title: Text(
          sender,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Icon(Icons.camera_alt),
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

  void _getImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      // Handle the picked image here
    }
  }

  void _getImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Handle the picked image here
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AnimeChatScreen(),
  ));
}
