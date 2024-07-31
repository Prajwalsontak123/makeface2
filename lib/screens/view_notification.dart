import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otheruser_profile_screen.dart';


class ViewNotificationPage extends StatefulWidget {
  @override
  _ViewNotificationPageState createState() => _ViewNotificationPageState();
}

class _ViewNotificationPageState extends State<ViewNotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserUniqueName;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserUniqueName();
  }

  Future<void> _fetchCurrentUserUniqueName() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('loggedin_users')
          .doc(currentUser.uid)
          .get();
      setState(() {
        currentUserUniqueName = userDoc.get('unique_name');
      });
    }
  }

  Future<String> _fetchUsername(String fromUniqueName) async {
    QuerySnapshot userSnapshot = await _firestore
        .collection('loggedin_users')
        .where('unique_name', isEqualTo: fromUniqueName)
        .limit(1)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      return userSnapshot.docs.first.get('username');
    } else {
      return 'Unknown User';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: currentUserUniqueName == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('notifications')
                  .where('to_unique_name', isEqualTo: currentUserUniqueName)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No notifications'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var notification = snapshot.data!.docs[index];
                    String fromUniqueName = notification.get('from_unique_name') ?? 'Unknown';

                    return FutureBuilder<String>(
                      future: _fetchUsername(fromUniqueName),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Loading...'),
                          );
                        }
                        if (userSnapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${userSnapshot.error}'),
                          );
                        }
                        String username = userSnapshot.data ?? 'Unknown User';
                        return _buildNotificationTile(notification, username);
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildNotificationTile(DocumentSnapshot document, String username) {
    String type = document.get('type') ?? 'Unknown';
    Timestamp? timestamp = document.get('timestamp') as Timestamp?;

    return ListTile(
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherUserProfileScreen(
                username: username,
                profileImage: '', // Fetch profileImage if needed
                bio: '', // Fetch bio if needed
                otherUserUniqueName: document.get('from_unique_name') ?? 'Unknown',
              ),
            ),
          );
        },
        child: Text(
          '$username $type',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      subtitle: timestamp != null
          ? Text(_formatTimestamp(timestamp))
          : Text('No timestamp'),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}