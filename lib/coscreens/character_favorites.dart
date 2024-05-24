import 'package:flutter/material.dart';

class CharacterFavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Character Favorites'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          CharacterFavoriteCard(
            name: 'Character 1',
            imageUrl: 'assets/character1.jpg', // Add your image asset path
            description: 'Description of Character 1.',
          ),
          CharacterFavoriteCard(
            name: 'Character 2',
            imageUrl: 'assets/character2.jpg', // Add your image asset path
            description: 'Description of Character 2.',
          ),
          CharacterFavoriteCard(
            name: 'Character 3',
            imageUrl: 'assets/character3.jpg', // Add your image asset path
            description: 'Description of Character 3.',
          ),
          // Add more character favorites as needed
        ],
      ),
    );
  }
}

class CharacterFavoriteCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;

  CharacterFavoriteCard({
    required this.name,
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
          name,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        onTap: () {
          // Add logic to navigate to the details page of the character
          print('Tapped on $name');
        },
      ),
    );
  }
}
