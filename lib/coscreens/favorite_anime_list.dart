import 'package:flutter/material.dart';

class FavoriteAnimeListPage extends StatelessWidget {
  // Example list of favorite anime
  final List<Anime> favoriteAnimeList = [
    Anime(
      title: 'Your Favorite Anime 1',
      imageUrl: 'assets/anime1.jpg',
      description: 'Description of your favorite anime 1.',
    ),
    Anime(
      title: 'Your Favorite Anime 2',
      imageUrl: 'assets/anime2.jpg',
      description: 'Description of your favorite anime 2.',
    ),
    // Add more favorite anime here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Anime List'),
      ),
      body: ListView.builder(
        itemCount: favoriteAnimeList.length,
        itemBuilder: (context, index) {
          final anime = favoriteAnimeList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(anime.imageUrl),
            ),
            title: Text(anime.title),
            subtitle: Text(anime.description),
            onTap: () {
              // Navigate to details page when an item is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailsPage(anime: anime),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Anime {
  final String title;
  final String imageUrl;
  final String description;

  Anime({
    required this.title,
    required this.imageUrl,
    required this.description,
  });
}

class AnimeDetailsPage extends StatelessWidget {
  final Anime anime;

  AnimeDetailsPage({required this.anime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anime.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(anime.imageUrl),
            SizedBox(height: 20),
            Text(anime.description),
          ],
        ),
      ),
    );
  }
}
