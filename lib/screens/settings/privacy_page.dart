import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account Privacy'),
          _buildPrivacyTile('Private Account',
              'Only people you approve can see your photos and videos.', false),
          _buildPrivacyTile(
              'Activity Status', 'Show your activity status', true),
          _buildPrivacyTile('Story Sharing', 'Allow sharing your story', false),
          _buildPrivacyTile(
              'Story Reply', 'Allow people to reply to your story', true),
          _buildPrivacyTile(
              'Message Replies', 'Allow replies to your messages', false),
          _buildPrivacyTile('Show Activity', 'Show when you are active', true),
          _buildPrivacyTile(
              'Close Friends', 'Share stories only with close friends', false),
          _buildPrivacyTile(
              'Discoverability', 'Let others find you by your username', true),
          SizedBox(height: 20.0),
          _buildSectionHeader('Connections'),
          _buildPrivacyTile(
              'Follow Requests', 'Approve follow requests manually', false),
          _buildPrivacyTile('Search History', 'Save your search history', true),
          _buildPrivacyTile('Connections', 'See your connections', false),
          SizedBox(height: 20.0),
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

  Widget _buildPrivacyTile(String title, String subtitle, bool value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          // Implement logic to update privacy settings
          // For now, print the new value
          print('$title: $newValue');
        },
      ),
    );
  }
}
