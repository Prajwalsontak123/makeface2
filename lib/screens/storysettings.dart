import 'package:flutter/material.dart';

class StorySettingsPage extends StatefulWidget {
  @override
  _StorySettingsPageState createState() => _StorySettingsPageState();
}

class _StorySettingsPageState extends State<StorySettingsPage> {
  bool allowMessageReplies = true;
  String messageReplyOption = 'Everyone';
  bool saveToGallery = false;
  bool saveToArchive = true;
  bool allowSharingToStory = true;
  bool allowSharingToMessages = true;
  bool shareToFacebook = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story'),
        actions: [
          TextButton(
            child: Text('Done'),
            onPressed: () {
              // Handle Done action
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Viewing'),
          ),
          ListTile(
            title: Text('Hide story from'),
            subtitle: Text('0 people'),
            onTap: () {
              // Handle hide story from
            },
          ),
          ListTile(
            title: Text('Close friends'),
            subtitle: Text('0 people'),
            onTap: () {
              // Handle close friends
            },
          ),
          ListTile(
            title: Text('Replying'),
          ),
          ListTile(
            title: Text('Allow message replies'),
            subtitle: Text('Choose who can reply to your story.'),
          ),
          RadioListTile(
            title: Text('Everyone'),
            value: 'Everyone',
            groupValue: messageReplyOption,
            onChanged: (value) {
              setState(() {
                messageReplyOption = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('People you follow'),
            value: 'People you follow',
            groupValue: messageReplyOption,
            onChanged: (value) {
              setState(() {
                messageReplyOption = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Off'),
            value: 'Off',
            groupValue: messageReplyOption,
            onChanged: (value) {
              setState(() {
                messageReplyOption = value.toString();
              });
            },
          ),
          SwitchListTile(
            title: Text('Save story to Gallery'),
            subtitle:
                Text('Automatically save your story to your phone\'s gallery.'),
            value: saveToGallery,
            onChanged: (value) {
              setState(() {
                saveToGallery = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Save story to archive'),
            subtitle: Text(
                'Automatically save your story to your archive so you don\'t have to save it to your phone. Only you can see your archive.'),
            value: saveToArchive,
            onChanged: (value) {
              setState(() {
                saveToArchive = value;
              });
            },
          ),
          ListTile(
            title: Text('Sharing'),
          ),
          SwitchListTile(
            title: Text('Allow sharing to story'),
            subtitle: Text(
                'Other people can add your feed posts and IGTV videos to their stories. Your username will always show up with your post.'),
            value: allowSharingToStory,
            onChanged: (value) {
              setState(() {
                allowSharingToStory = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Allow sharing to messages'),
            subtitle: Text(
                'Let others share photos and videos from your story in a message.'),
            value: allowSharingToMessages,
            onChanged: (value) {
              setState(() {
                allowSharingToMessages = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Share your story to Facebook'),
            subtitle: Text(
                'Automatically share your Instagram story as your Facebook story.'),
            value: shareToFacebook,
            onChanged: (value) {
              setState(() {
                shareToFacebook = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
