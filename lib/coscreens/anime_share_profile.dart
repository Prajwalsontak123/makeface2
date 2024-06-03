import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:url_launcher/url_launcher.dart'; // For launching WhatsApp and email

class ProfileSharingPage extends StatelessWidget {
  final String profileLink;

  ProfileSharingPage({required this.profileLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildButton(
              onPressed: () => _copyToClipboard(context, profileLink),
              label: 'Copy Profile Link',
            ),
            SizedBox(height: 20),
            _buildButton(
              onPressed: () => _shareViaWhatsApp(context, profileLink),
              label: 'Share via WhatsApp',
            ),
            SizedBox(height: 20),
            _buildButton(
              onPressed: () => _shareViaEmail(
                  context, 'your_email@example.com', profileLink),
              label: 'Share via Email',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {required VoidCallback onPressed, required String label}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar(context, 'Profile link copied to clipboard');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _shareViaWhatsApp(BuildContext context, String text) async {
    String url = 'whatsapp://send?text=$text';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showSnackBar(context, 'Could not launch WhatsApp');
    }
  }

  void _shareViaEmail(
      BuildContext context, String emailAddress, String text) async {
    String subject = 'Check out my profile!';
    String body = 'Here is the link to my profile: $text';
    String url = 'mailto:$emailAddress?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showSnackBar(context, 'Could not launch email');
    }
  }
}
