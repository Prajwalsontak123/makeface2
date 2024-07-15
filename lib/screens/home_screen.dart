import 'package:flutter/material.dart';
import 'package:makeface2/screens/anime_chat.dart';
import 'package:makeface2/screens/circle_profile.dart';
import 'package:makeface2/screens/circle_screen.dart';
import '../coscreens/home_searchbar.dart';
import 'story_creation_page.dart';
import 'bottom_nav_bar.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeSearchBar()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnimeChatScreen()),
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
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StoryCreationPage()),
                        );
                      } else {
                        // Handle story viewing
                      }
                    },
                    child: Container(
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
                          if (index == 0)
                            Positioned(
                              bottom: 25,
                              right: 2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 20,
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set the current index to 0 (HomeScreen)
        onTap: (index) {
          // Navigate to the corresponding screen based on the tapped index
          switch (index) {
            case 0:
              // Do nothing, already in HomeScreen
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
              // Show dialog box when "Add Post" icon is tapped
              _showAddPostOptions(context);
              break;
            case 4:
              // Navigate to CircleProfile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CircleProfile()),
              );
              break;
          }
        },
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
                  // Handle camera option
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Local Storage'),
                onTap: () {
                  // Handle local storage option
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}