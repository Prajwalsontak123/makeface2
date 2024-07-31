import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otheruser_profile_screen.dart';

class SupporterList extends StatefulWidget {
  @override
  _SupporterListState createState() => _SupporterListState();
}

class _SupporterListState extends State<SupporterList> {
  late String _userId;
  List<DocumentSnapshot> _supporters = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSupporters();
  }

  Future<void> _fetchSupporters() async {
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

          if (userData?['supporting'] != null) {
            List<dynamic> supportingList = userData?['supporting'];

            if (supportingList.isNotEmpty) {
              // Fetch all users whose unique_name is in the supporting list
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('loggedin_users')
                  .where('unique_name', whereIn: supportingList)
                  .get();

              setState(() {
                _supporters = querySnapshot.docs;
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
        _errorMessage = 'Failed to fetch supporters: $e';
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
        title: Text('Following'),
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
              : _supporters.isEmpty
                  ? Center(child: Text('You are not following anyone yet.'))
                  : ListView.builder(
                      itemCount: _supporters.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot supporter = _supporters[index];
                        final supporterData = supporter.data() as Map<String, dynamic>?;

                        if (supporterData == null) {
                          return SizedBox.shrink();
                        }

                        String username = supporterData['username'] ?? '';
                        String uniqueName = supporterData['unique_name'] ?? '';
                        String profileImageUrl = supporterData['profile_image'] ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: profileImageUrl.isNotEmpty
                                ? NetworkImage(profileImageUrl)
                                : AssetImage('assets/images/avatar.png') as ImageProvider,
                          ),
                          title: Text(username.isNotEmpty ? username : uniqueName),
                          subtitle: username.isNotEmpty ? Text('@$uniqueName') : null,
                          onTap: () {
                            _navigateToUserProfile(context, supporterData);
                          },
                        );
                      },
                    ),
    );
  }
}