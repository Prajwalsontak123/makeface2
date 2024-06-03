import 'package:flutter/material.dart';

class CloseFriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Close Friends'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Add Close Friends'),
          _buildSettingsTile(Icons.search, 'Search', () {
            // Placeholder for action when Search is tapped
            print('Search tapped');
          }),

          _buildSectionHeader('Your Close Friends List'),
          _buildCloseFriendTile('John Doe', 'assets/profile_image.jpg'),
          _buildCloseFriendTile('Jane Smith', 'assets/profile_image.jpg'),
          // Add more close friends here

          SizedBox(height: 20.0), // Add some spacing at the bottom
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      color: Colors.grey[200],
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildCloseFriendTile(String name, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      trailing: Icon(Icons.close),
      onTap: () {
        // Placeholder for action when close friend is tapped
        print('$name tapped');
      },
    );
  }
}
