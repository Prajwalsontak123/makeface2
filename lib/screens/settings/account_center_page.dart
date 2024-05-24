import 'package:flutter/material.dart';

class AccountCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Center'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Profile Section
          Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage(
                    'assets/profile_image.jpg'), // Replace with your profile image
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe', // Replace with your username
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'john.doe@example.com', // Replace with your email
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0),

          // Account Management Options
          _buildAccountOption(context, Icons.edit, 'Edit Profile', () {
            // Navigate to Edit Profile Page
          }),
          _buildAccountOption(context, Icons.lock, 'Privacy Settings', () {
            // Navigate to Privacy Settings Page
          }),
          _buildAccountOption(context, Icons.security, 'Security Settings', () {
            // Navigate to Security Settings Page
          }),
          _buildAccountOption(
              context, Icons.notifications, 'Notifications Settings', () {
            // Navigate to Notifications Settings Page
          }),
          _buildAccountOption(context, Icons.logout, 'Log Out', () {
            // Log out action
          }),
        ],
      ),
    );
  }

  Widget _buildAccountOption(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
