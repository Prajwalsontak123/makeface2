import 'package:flutter/material.dart';

class SavedPostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts'),
      ),
      body: ListView(
        children: [
          _buildSavedPostCard('https://via.placeholder.com/150',
              isAudio: false),
          _buildSavedPostCard('https://via.placeholder.com/150',
              isAudio: false),
          _buildSavedPostCard('https://via.placeholder.com/150', isAudio: true),
          _buildSavedPostCard('https://via.placeholder.com/150', isAudio: true),
        ],
      ),
    );
  }

  Widget _buildSavedPostCard(String imageUrl, {required bool isAudio}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    // Implement like functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    // Implement save functionality
                  },
                ),
                if (isAudio)
                  IconButton(
                    icon: Icon(Icons.music_note),
                    onPressed: () {
                      // Implement save audio functionality
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
