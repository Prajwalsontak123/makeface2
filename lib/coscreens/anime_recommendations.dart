import 'package:flutter/material.dart';

class AnimeRecommendationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Recommendations'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          AnimeRecommendationCard(
            title: 'Recommended Anime 1',
            imageUrl: 'assets/anime1.jpg', // Add your image asset path
            description: 'Description of Recommended Anime 1.',
          ),
          AnimeRecommendationCard(
            title: 'Recommended Anime 2',
            imageUrl: 'assets/anime2.jpg', // Add your image asset path
            description: 'Description of Recommended Anime 2.',
          ),
          AnimeRecommendationCard(
            title: 'Recommended Anime 3',
            imageUrl: 'assets/anime3.jpg', // Add your image asset path
            description: 'Description of Recommended Anime 3.',
          ),
          // Add more recommendations as needed
        ],
      ),
    );
  }
}

class AnimeRecommendationCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;

  AnimeRecommendationCard({
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        onTap: () {
          // Add logic to navigate to the details page of the recommendation
          print('Tapped on $title');
        },
      ),
    );
  }
}
