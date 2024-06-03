import 'package:flutter/material.dart';

class DownloadsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Downloaded Posts'),
          _buildDownloadItem('Post 1', 'assets/post1.jpg'),
          _buildDownloadItem('Post 2', 'assets/post2.jpg'),
          _buildDownloadItem('Post 3', 'assets/post3.jpg'),
          SizedBox(height: 20.0),
          _buildSectionHeader('Downloaded Videos'),
          _buildDownloadItem('Video 1', 'assets/video1.jpg'),
          _buildDownloadItem('Video 2', 'assets/video2.jpg'),
          _buildDownloadItem('Video 3', 'assets/video3.jpg'),
          SizedBox(height: 20.0),
          _buildSectionHeader('Downloaded Audios'),
          _buildDownloadItem('Audio 1', 'assets/audio1.jpg'),
          _buildDownloadItem('Audio 2', 'assets/audio2.jpg'),
          _buildDownloadItem('Audio 3', 'assets/audio3.jpg'),
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

  Widget _buildDownloadItem(String title, String imagePath) {
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
