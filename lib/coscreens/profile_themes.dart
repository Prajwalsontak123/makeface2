import 'package:flutter/material.dart';

class ProfileThemesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Themes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Profile Themes',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            // Add dummy themes here
            ProfileThemeCard(themeName: 'Theme 1'),
            ProfileThemeCard(themeName: 'Theme 2'),
            ProfileThemeCard(themeName: 'Theme 3'),
          ],
        ),
      ),
    );
  }
}

class ProfileThemeCard extends StatelessWidget {
  final String themeName;

  ProfileThemeCard({required this.themeName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(themeName),
        onTap: () {
          // Add logic to select the theme
          // For now, just print the selected theme
          print('Selected Theme: $themeName');
        },
      ),
    );
  }
}
