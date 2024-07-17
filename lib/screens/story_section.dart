import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:makeface2/screens/story_creation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorySection extends StatelessWidget {
  Future<bool> hasStory(String uniqueName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('stories/$uniqueName');
      final ListResult result = await storageRef.listAll();
      return result.items.isNotEmpty;
    } catch (e) {
      print('Error checking for story: $e');
      return false;
    }
  }

  Future<List<String>> getUniqueNames() async {
    final snapshot = await FirebaseFirestore.instance.collection('loggedin_users').get();
    return snapshot.docs.map((doc) => doc['unique_name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('User not logged in'));
    }

    return FutureBuilder<List<String>>(
      future: getUniqueNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final uniqueNames = snapshot.data ?? [];

        return Container(
          height: 100.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: uniqueNames.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _buildCurrentUserStory(context, user.uid);
              } else {
                return _buildOtherUserStory(context, uniqueNames[index - 1]);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildCurrentUserStory(BuildContext context, String userId) {
    return FutureBuilder<bool>(
      future: hasStory(userId),
      builder: (context, snapshot) {
        bool hasActiveStory = snapshot.data ?? false;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Stack(
            children: [
              _buildStoryAvatar(hasActiveStory, null),
              Positioned(
                bottom: 27,
                right: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryCreationPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOtherUserStory(BuildContext context, String uniqueName) {
    return FutureBuilder<bool>(
      future: hasStory(uniqueName),
      builder: (context, snapshot) {
        bool hasActiveStory = snapshot.data ?? false;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: _buildStoryAvatar(hasActiveStory, uniqueName),
        );
      },
    );
  }

  Widget _buildStoryAvatar(bool hasActiveStory, String? uniqueName) {
    return GestureDetector(
      onTap: hasActiveStory
          ? () {
              // Handle story viewing
            }
          : null,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasActiveStory
              ? LinearGradient(
                  colors: [Colors.purple, Colors.pink, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: CircleAvatar(
          radius: 32.0,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 30.0,
            backgroundColor: const Color.fromARGB(255, 173, 175, 177),
            child: uniqueName != null
                ? Text(
                    uniqueName[0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  )
                : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}