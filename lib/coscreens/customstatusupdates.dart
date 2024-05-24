import 'package:flutter/material.dart';

class CustomStatusUpdatesPage extends StatefulWidget {
  @override
  _CustomStatusUpdatesPageState createState() =>
      _CustomStatusUpdatesPageState();
}

class _CustomStatusUpdatesPageState extends State<CustomStatusUpdatesPage> {
  String _statusMessage = '';
  String _selectedEmoji = '😊'; // Default emoji
  String _notes = '';

  void _updateStatusMessage(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  void _selectEmoji(String emoji) {
    setState(() {
      _selectedEmoji = emoji;
    });
  }

  void _updateNotes(String notes) {
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Status Updates'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Status:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '$_selectedEmoji $_statusMessage',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your status message',
                border: OutlineInputBorder(),
              ),
              onChanged: _updateStatusMessage,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmojiButton('😊'),
                _buildEmojiButton('😂'),
                _buildEmojiButton('😎'),
                _buildEmojiButton('🥰'),
              ],
            ),
            SizedBox(height: 24.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Add notes (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: _updateNotes,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return InkWell(
      onTap: () => _selectEmoji(emoji),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
              color: _selectedEmoji == emoji ? Colors.blue : Colors.grey),
        ),
        child: Text(
          emoji,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
