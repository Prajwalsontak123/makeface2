import 'package:flutter/material.dart';

class AchievementsAndBadgesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements and Badges'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          AchievementBadgeTile(
            title: 'First Purchase',
            description: 'Make your first purchase!',
            imageUrl: 'assets/badge1.jpg',
          ),
          AchievementBadgeTile(
            title: 'Reviewer',
            description: 'Leave 10 product reviews',
            imageUrl: 'assets/badge2.jpg',
          ),
          AchievementBadgeTile(
            title: 'Prime Member',
            description: 'Subscribe to Amazon Prime',
            imageUrl: 'assets/badge3.jpg',
          ),
          AchievementBadgeTile(
            title: 'Super Shopper',
            description: 'Spend over \$1000 in a year',
            imageUrl: 'assets/badge4.jpg',
          ),
          // Add more achievement badges as needed
        ],
      ),
    );
  }
}

class AchievementBadgeTile extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  AchievementBadgeTile({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
    );
  }
}
