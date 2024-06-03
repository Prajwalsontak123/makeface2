import 'package:flutter/material.dart';

class TimeSpentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Spent'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Daily Activity'),
          _buildSettingsTile(Icons.access_time, 'View Daily Activity', () {
            // Placeholder for action when View Daily Activity is tapped
            print('View Daily Activity tapped');
          }),

          _buildSectionHeader('Daily Reminder'),
          _buildSettingsTile(Icons.notifications_active, 'Set Daily Reminder',
              () {
            // Placeholder for action when Set Daily Reminder is tapped
            print('Set Daily Reminder tapped');
          }),

          _buildSectionHeader('Mute Notifications'),
          _buildSettingsTile(Icons.notifications_off, 'Mute Push Notifications',
              () {
            // Placeholder for action when Mute Push Notifications is tapped
            print('Mute Push Notifications tapped');
          }),

          _buildSectionHeader('Manage Your Time'),
          _buildSettingsTile(Icons.access_time, 'Set Time Limit', () {
            // Placeholder for action when Set Time Limit is tapped
            print('Set Time Limit tapped');
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

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
