import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Login Security'),
          _buildSettingsTile(Icons.lock, 'Password', () {
            // Placeholder for action when Password is tapped
            print('Password tapped');
          }),
          _buildSettingsTile(Icons.security, 'Two-Factor Authentication', () {
            // Placeholder for action when Two-Factor Authentication is tapped
            print('Two-Factor Authentication tapped');
          }),
          _buildSettingsTile(Icons.devices, 'Login Activity', () {
            // Placeholder for action when Login Activity is tapped
            print('Login Activity tapped');
          }),
          _buildSettingsTile(Icons.phonelink_lock, 'Saved Login Info', () {
            // Placeholder for action when Saved Login Info is tapped
            print('Saved Login Info tapped');
          }),
          _buildSettingsTile(Icons.security_update, 'Security Checkup', () {
            // Placeholder for action when Security Checkup is tapped
            print('Security Checkup tapped');
          }),
          _buildSectionHeader('Data and History'),
          _buildSettingsTile(Icons.history, 'Access Data', () {
            // Placeholder for action when Access Data is tapped
            print('Access Data tapped');
          }),
          _buildSettingsTile(Icons.download, 'Download Data', () {
            // Placeholder for action when Download Data is tapped
            print('Download Data tapped');
          }),
          _buildSettingsTile(Icons.remove_circle_outline, 'Apps and Websites',
              () {
            // Placeholder for action when Apps and Websites is tapped
            print('Apps and Websites tapped');
          }),
          _buildSettingsTile(Icons.perm_device_information, 'Device Security',
              () {
            // Placeholder for action when Device Security is tapped
            print('Device Security tapped');
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
