import 'package:flutter/material.dart';

class DiscussionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion History'),
      ),
      body: ListView.builder(
        itemCount: 20, // Placeholder for discussion items
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Discussion ${index + 1}'),
            subtitle: Text('Details of discussion ${index + 1}'),
            onTap: () {
              // Add logic to navigate to the details of the discussion
              print('Tapped on discussion ${index + 1}');
            },
          );
        },
      ),
    );
  }
}
