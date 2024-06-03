import 'package:flutter/material.dart';

class ArchivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archives'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Stories Archive'),
          _buildArchiveItem('Story 1', 'assets/story1.jpg'),
          _buildArchiveItem('Story 2', 'assets/story2.jpg'),
          _buildArchiveItem('Story 3', 'assets/story3.jpg'),
          SizedBox(height: 20.0),
          _buildSectionHeader('Posts Archive'),
          _buildArchiveItem('Post 1', 'assets/post1.jpg'),
          _buildArchiveItem('Post 2', 'assets/post2.jpg'),
          _buildArchiveItem('Post 3', 'assets/post3.jpg'),
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

  Widget _buildArchiveItem(String title, String imagePath) {
    return ListTile(
      leading: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(title),
      onTap: () {
        // Handle tap
        print('$title tapped');
      },
    );
  }
}
