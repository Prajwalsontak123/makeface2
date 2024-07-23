import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otheruser_profile_screen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserUniqueName;

  @override
  void initState() {
    super.initState();
    _getCurrentUserUniqueName();
  }

  Future<void> _getCurrentUserUniqueName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('loggedin_users').doc(user.uid).get();
      setState(() {
        currentUserUniqueName = userDoc['unique_name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('notifications')
            .where('to_unique_name', isEqualTo: currentUserUniqueName)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications yet.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var notification = snapshot.data!.docs[index];
              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('loggedin_users')
                    .where('unique_name', isEqualTo: notification['from_unique_name'])
                    .get()
                    .then((querySnapshot) => querySnapshot.docs.first),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text('Loading...'));
                  }

                  if (!userSnapshot.hasData) {
                    return ListTile(title: Text('User not found'));
                  }

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  String username = userData['username'];
                  String profileImage = userData['profile_image'] ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profileImage.isNotEmpty
                          ? NetworkImage(profileImage)
                          : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                    title: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _navigateToUserProfile(context, userData),
                          ),
                          TextSpan(
                            text: notification['type'] == 'started_supporting'
                                ? ' started supporting you'
                                : ' you started supporting',
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      _formatTimestamp(notification['timestamp'] as Timestamp),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToUserProfile(BuildContext context, Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfileScreen(
          username: userData['username'],
          profileImage: userData['profile_image'] ?? '',
          bio: userData['bio'] ?? '',
          otherUserUniqueName: userData['unique_name'],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}