import 'package:flutter/material.dart';

class FollowAndInvitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Follow and Invite Friends'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Follow Friends'),
          _buildSettingsTile(Icons.contacts, 'Follow Contacts', () {
            // Placeholder for action when Follow Contacts is tapped
            print('Follow Contacts tapped');
          }),
          _buildSettingsTile(Icons.facebook, 'Follow on Facebook', () {
            // Placeholder for action when Follow on Facebook is tapped
            print('Follow on Facebook tapped');
          }),
          _buildSectionHeader('Invite Friends'),
          _buildSettingsTile(Icons.email, 'Invite via Email', () {
            // Placeholder for action when Invite via Email is tapped
            print('Invite via Email tapped');
          }),
          _buildSettingsTile(Icons.sms, 'Invite via SMS', () {
            // Placeholder for action when Invite via SMS is tapped
            print('Invite via SMS tapped');
          }),
          _buildSettingsTile(Icons.share, 'Share Profile Link', () {
            // Placeholder for action when Share Profile Link is tapped
            print('Share Profile Link tapped');
          }),
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
}
