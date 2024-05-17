import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'anime_chat.dart';
import 'circle_screen.dart'; // Import the circle_screen.dart file

void main() {
  runApp(CircleProfile());
}

class CircleProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // This will pop the current screen and go back
            },
          ),
        ),
        body: CircleProfileSection(),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(color: Colors.black),
          unselectedIconTheme: IconThemeData(color: Colors.black),
          currentIndex: 2,
          onTap: (index) {
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
      ),
    );
  }
}

class CircleProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner and Profile Picture
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 150.0,
                width: double.infinity,
                color: Colors.blue, // You can change the color here
              ),
              Positioned(
                bottom: 0.0,
                left: 16.0, // Adjust this value for left alignment
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          // Name and Headline
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Software Developer at XYZ Corp',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          // Summary
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Experienced software developer with expertise in Flutter, Java, and Python. Passionate about building innovative applications.',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(height: 20.0),
          // Post Section
          SectionTitle(title: 'Posts'),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: List.generate(
              9,
              (index) => PostItem(
                imageUrl: 'https://via.placeholder.com/400',
              ),
            ),
          ),
          // Add more sections for Education, Skills, Contact Information, etc.
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final String imageUrl;

  const PostItem({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
