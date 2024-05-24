import 'package:flutter/material.dart';

class BlockedAccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Accounts'),
      ),
      body: ListView(
        children: [
          _buildBlockedAccountTile('John Doe', 'assets/profile_image.jpg'),
          _buildBlockedAccountTile('Jane Smith', 'assets/profile_image.jpg'),
          // Add more blocked accounts here

          SizedBox(height: 20.0), // Add some spacing at the bottom
        ],
      ),
    );
  }

  Widget _buildBlockedAccountTile(String name, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      trailing: ElevatedButton(
        onPressed: () {
          // Placeholder for action when Unblock is tapped
          print('Unblock $name');
        },
        child: Text('Unblock'),
      ),
    );
  }
}
