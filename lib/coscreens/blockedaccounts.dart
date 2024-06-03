import 'package:flutter/material.dart';

class BlockedAccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder list of blocked accounts
    List<String> blockedAccounts = [
      'User1',
      'User2',
      'User3',
      // Add more blocked accounts here
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Accounts'),
      ),
      body: ListView.separated(
        itemCount: blockedAccounts.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final blockedAccount = blockedAccounts[index];
          return ListTile(
            leading: CircleAvatar(
              // Placeholder for user avatar
              child: Icon(Icons.person),
            ),
            title: Text(
              blockedAccount,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('This user is blocked'),
            trailing: ElevatedButton(
              onPressed: () {
                // Placeholder for action when tapping on unblock button
                print('Unblock $blockedAccount');
              },
              child: Text('Unblock'),
            ),
            onTap: () {
              // Placeholder for action when tapping on blocked account
              print('Tapped on blocked account: $blockedAccount');
            },
          );
        },
      ),
    );
  }
}
