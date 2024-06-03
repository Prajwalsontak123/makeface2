import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget {
  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Add logic here to handle adding the new account
                String username = _usernameController.text;
                String password = _passwordController.text;
                // Add code to save the account details or perform authentication
                // For demonstration, simply print the entered credentials
                print('Username: $username');
                print('Password: $password');
                // Clear the text fields after adding the account
                _usernameController.clear();
                _passwordController.clear();
                // Show a confirmation dialog or navigate back to the settings page
                Navigator.pop(context);
              },
              child: Text('Add Account'),
            ),
          ],
        ),
      ),
    );
  }
}
