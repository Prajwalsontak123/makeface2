import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeface2/screens/login_screen.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Sign out the user from Firebase
            await FirebaseAuth.instance.signOut();
            // Navigate to the login screen
            _navigateToLoginScreen(context);
          },
          child: Text('Logout'),
        ),
      ),
    );
  }

  // Method to navigate to the login screen
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
