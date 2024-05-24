import 'package:flutter/material.dart';

class LogoutOfAllAccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout of All Accounts'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add logic here to handle logout of all accounts
            // For demonstration, navigate back to the settings page
            Navigator.pop(context);
          },
          child: Text('Logout of All Accounts'),
        ),
      ),
    );
  }
}
