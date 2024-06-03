import 'package:flutter/material.dart';

class HideStoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hide Story From'),
      ),
      body: ListView(
        children: [
          _buildHideStoryTile('John Doe', 'assets/profile_image.jpg'),
          _buildHideStoryTile('Jane Smith', 'assets/profile_image.jpg'),
          // Add more accounts here

          SizedBox(height: 20.0), // Add some spacing at the bottom
        ],
      ),
    );
  }

  Widget _buildHideStoryTile(String name, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      trailing: Switch(
        value: false, // Change this to a dynamic value if needed
        onChanged: (bool value) {
          // Placeholder for action when switch is toggled
          print('Hide story from $name: $value');
        },
      ),
    );
  }
}
