import 'package:flutter/material.dart';

class YourActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Activity'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Time Spent'),
          _buildSettingsTile(Icons.watch_later, 'Time Spent', () {
            // Placeholder for action when Time Spent is tapped
            print('Time Spent tapped');
          }),
          _buildSettingsTile(Icons.alarm, 'Set Daily Reminder', () {
            // Placeholder for action when Set Daily Reminder is tapped
            print('Set Daily Reminder tapped');
          }),
          _buildSettingsTile(Icons.timer_off, 'Mute Push Notifications', () {
            // Placeholder for action when Mute Push Notifications is tapped
            print('Mute Push Notifications tapped');
          }),
          _buildSectionHeader('Recent Searches'),
          _buildSettingsTile(Icons.search, 'View All', () {
            // Placeholder for action when View All is tapped
            print('View All tapped');
          }),
          _buildSettingsTile(Icons.delete, 'Clear All', () {
            // Placeholder for action when Clear All is tapped
            print('Clear All tapped');
          }),
          _buildSectionHeader('Links You\'ve Visited'),
          _buildSettingsTile(Icons.link, 'View Links', () {
            // Placeholder for action when View Links is tapped
            print('View Links tapped');
          }),
          _buildSectionHeader('Account History'),
          _buildSettingsTile(Icons.history, 'View Account History', () {
            // Placeholder for action when View Account History is tapped
            print('View Account History tapped');
          }),
          _buildSectionHeader('Archived Posts'),
          _buildSettingsTile(Icons.archive, 'View Archived Posts', () {
            // Placeholder for action when View Archived Posts is tapped
            print('View Archived Posts tapped');
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
