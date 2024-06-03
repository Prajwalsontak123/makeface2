import 'package:flutter/material.dart';

class CustomAvatarCoverPage extends StatefulWidget {
  @override
  _CustomAvatarCoverPageState createState() => _CustomAvatarCoverPageState();
}

class _CustomAvatarCoverPageState extends State<CustomAvatarCoverPage> {
  String _avatarImageUrl = ''; // Placeholder for avatar image URL
  String _coverImageUrl = ''; // Placeholder for cover image URL

  // Function to update avatar image
  void _updateAvatarImage(String imageUrl) {
    setState(() {
      _avatarImageUrl = imageUrl;
    });
  }

  // Function to update cover image
  void _updateCoverImage(String imageUrl) {
    setState(() {
      _coverImageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Avatar & Cover Photo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display current avatar image
            _avatarImageUrl.isNotEmpty
                ? Image.network(_avatarImageUrl)
                : Placeholder(),
            // Button to select/update avatar image
            ElevatedButton(
              onPressed: () {
                // Placeholder for action to select/update avatar image
                _updateAvatarImage(
                    'https://via.placeholder.com/150'); // Sample URL
              },
              child: Text('Select Avatar'),
            ),
            SizedBox(height: 20),
            // Display current cover photo
            _coverImageUrl.isNotEmpty
                ? Image.network(_coverImageUrl)
                : Placeholder(),
            // Button to select/update cover photo
            ElevatedButton(
              onPressed: () {
                // Placeholder for action to select/update cover photo
                _updateCoverImage(
                    'https://via.placeholder.com/350'); // Sample URL
              },
              child: Text('Select Cover Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
