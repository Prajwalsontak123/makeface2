import 'package:flutter/material.dart';
import 'package:makeface2/screens/circle_profile.dart';
import 'package:makeface2/screens/circle_screen.dart';
import 'package:makeface2/screens/home_screen.dart';
import 'package:makeface2/screens/profile_home.dart'; // Import profile_home.dart
import 'bottom_nav_bar.dart';

class HomeChatScreen extends StatefulWidget {
  @override
  _HomeChatScreenState createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  List<String> _messages = [
    "Hey, how's it going?",
    "I'm doing well, thanks for asking!",
    "What about you?",
    "I'm good too. Just busy with work.",
    "That's great. We should catch up sometime.",
    "Definitely! Let's plan something soon.",
  ];

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show more options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('A'), // Example user initials
                  ),
                  title: Text('User $index'), // Example user name
                  subtitle: Text(_messages[index]), // Message content
                  trailing: Text('11:45'), // Example timestamp
                  onTap: () {
                    // Open chat detail screen
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set the current index to 1 (HomeChatScreen)
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
              // Do nothing, already in HomeChatScreen
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
              showAddPostOptions(context);
              break;
            case 4:
              // Navigate to profile_home.dart
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileHome()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Implement attachment functionality
            },
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _messages.add(_textEditingController.text);
        _textEditingController.clear();
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeChatScreen(),
  ));
}
