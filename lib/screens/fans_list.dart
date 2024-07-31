import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otheruser_profile_screen.dart';

class FansList extends StatefulWidget {
  @override
  _FansListState createState() => _FansListState();
}

class _FansListState extends State<FansList> {
  late String _userId;
  List<DocumentSnapshot> _fans = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFans();
  }

  Future<void> _fetchFans() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userId = user.uid;

        // Fetch current user data from loggedin_users collection
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('loggedin_users')
            .doc(_userId)
            .get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>?;

          if (userData?['fans'] != null) {
            List<dynamic> fansList = userData?['fans'];

            if (fansList.isNotEmpty) {
              // Fetch all users whose unique_name is in the fans list
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('loggedin_users')
                  .where('unique_name', whereIn: fansList)
                  .get();

              setState(() {
                _fans = querySnapshot.docs;
                _isLoading = false;
              });
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = 'User data not found.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'User not logged in.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch fans: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToUserProfile(BuildContext context, Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfileScreen(
          username: userData['username'] ?? userData['unique_name'],
          profileImage: userData['profile_image'] ?? '',
          bio: userData['bio'] ?? '',
          otherUserUniqueName: userData['unique_name'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fans'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _fans.isEmpty
                  ? Center(child: Text('You have no fans yet.'))
                  : ListView.builder(
                      itemCount: _fans.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot fan = _fans[index];
                        final fanData = fan.data() as Map<String, dynamic>?;

                        if (fanData == null) {
                          return SizedBox.shrink();
                        }

                        String username = fanData['username'] ?? '';
                        String uniqueName = fanData['unique_name'] ?? '';
                        String displayName = username.isNotEmpty ? username : uniqueName;
                        String profileImageUrl = fanData['profile_image'] ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: profileImageUrl.isNotEmpty
                                ? NetworkImage(profileImageUrl)
                                : AssetImage('assets/images/avatar.png') as ImageProvider,
                          ),
                          title: Text(displayName),
                          subtitle: username.isNotEmpty ? Text('@$uniqueName') : null,
                          onTap: () {
                            _navigateToUserProfile(context, fanData);
                          },
                        );
                      },
                    ),
    );
  }
}