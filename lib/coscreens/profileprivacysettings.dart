import 'package:flutter/material.dart';

class ProfilePrivacySettingsPage extends StatefulWidget {
  @override
  _ProfilePrivacySettingsPageState createState() =>
      _ProfilePrivacySettingsPageState();
}

class _ProfilePrivacySettingsPageState
    extends State<ProfilePrivacySettingsPage> {
  bool _isPrivate = false; // Default privacy setting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Privacy Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Private Account',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: _isPrivate,
              onChanged: (value) {
                setState(() {
                  _isPrivate = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'When your account is private, only approved followers can see your posts and stories.',
            ),
          ],
        ),
      ),
    );
  }
}
