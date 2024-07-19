import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InstagramStoryView(),
    );
  }
}

class InstagramStoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          StoryItem(
            username: 'vlad.vasylkevych',
            timeAgo: '6h',
            content: Image.network(
              'https://example.com/sunset_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          StoryItem(
            username: 'andrewkuttler',
            timeAgo: '19h',
            content: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Swirlin' around with @lilfoxx and @bose today for day three!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://example.com/coachella_image.jpg',
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Text(
                          'COACHELLA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final String username;
  final String timeAgo;
  final Widget content;

  StoryItem({
    required this.username,
    required this.timeAgo,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        content,
        Positioned(
          top: 40,
          left: 10,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('https://example.com/profile_pic.jpg'),
                radius: 20,
              ),
              SizedBox(width: 10),
              Text(
                username,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                timeAgo,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Send message', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}