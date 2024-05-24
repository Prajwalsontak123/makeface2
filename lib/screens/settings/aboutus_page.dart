import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        // This makes the content scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Our App',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'Our app is designed to provide the best social media experience. '
              'Connect with friends, share your moments, and explore new content every day.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Version',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              '1.0.0',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Developed By',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              'Your Company Name',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              'Email: support@yourcompany.com',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              'Phone: +1 234 567 890',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Follow Us',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                IconButton(
                  icon: Image.asset(
                      'assets/icons/facebook.png'), // Placeholder for Facebook icon
                  onPressed: () {
                    // Placeholder for Facebook link action
                  },
                ),
                IconButton(
                  icon: Image.asset(
                      'assets/icons/twitter.png'), // Placeholder for Twitter icon
                  onPressed: () {
                    // Placeholder for Twitter link action
                  },
                ),
                IconButton(
                  icon: Image.asset(
                      'assets/icons/instagram.png'), // Placeholder for Instagram icon
                  onPressed: () {
                    // Placeholder for Instagram link action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
