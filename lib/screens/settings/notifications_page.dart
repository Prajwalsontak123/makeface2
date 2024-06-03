import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('General'),
          _buildSettingsTile(Icons.pause, 'Pause All', () {
            // Placeholder for action when Pause All is tapped
            print('Pause All tapped');
          }),
          _buildSettingsTile(Icons.notifications_off, 'Quiet Mode', () {
            // Placeholder for action when Quiet Mode is tapped
            print('Quiet Mode tapped');
          }),
          _buildSectionHeader('Post Notifications'),
          _buildSettingsTile(Icons.add_box, 'Posts', () {
            // Placeholder for action when Posts is tapped
            print('Posts tapped');
          }),
          _buildSettingsTile(Icons.movie_creation, 'Stories and Reels', () {
            // Placeholder for action when Stories and Reels is tapped
            print('Stories and Reels tapped');
          }),
          _buildSettingsTile(Icons.comment, 'Comments', () {
            // Placeholder for action when Comments is tapped
            print('Comments tapped');
          }),
          _buildSectionHeader('Activity Notifications'),
          _buildSettingsTile(Icons.people, 'Followers and Following', () {
            // Placeholder for action when Followers and Following is tapped
            print('Followers and Following tapped');
          }),
          _buildSettingsTile(Icons.message, 'Messages', () {
            // Placeholder for action when Messages is tapped
            print('Messages tapped');
          }),
          _buildSettingsTile(Icons.phone, 'Calls', () {
            // Placeholder for action when Calls is tapped
            print('Calls tapped');
          }),
          _buildSettingsTile(Icons.favorite, 'Fundraisers', () {
            // Placeholder for action when Fundraisers is tapped
            print('Fundraisers tapped');
          }),
          _buildSettingsTile(Icons.cake, 'Birthdays', () {
            // Placeholder for action when Birthdays is tapped
            print('Birthdays tapped');
          }),
          _buildSettingsTile(Icons.shopping_bag, 'Shopping', () {
            // Placeholder for action when Shopping is tapped
            print('Shopping tapped');
          }),
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

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
