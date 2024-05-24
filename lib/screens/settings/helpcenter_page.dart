import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Help Topics'),
          _buildHelpTile('Account & Profile'),
          _buildHelpTile('Privacy & Safety'),
          _buildHelpTile('Using the App'),
          _buildHelpTile('Troubleshooting'),
          _buildHelpTile('Community Guidelines'),
          SizedBox(height: 20.0),
          _buildSectionHeader('FAQs'),
          _buildHelpTile('How to reset my password?'),
          _buildHelpTile('How to report a problem?'),
          _buildHelpTile('How to manage notifications?'),
          _buildHelpTile('How to delete my account?'),
          SizedBox(height: 20.0),
          _buildSectionHeader('Contact Us'),
          _buildHelpTile('Support Email: support@example.com'),
          _buildHelpTile('Phone: +1 234 567 890'),
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

  Widget _buildHelpTile(String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        // Handle tap on help item
        print('$title tapped');
      },
    );
  }
}
