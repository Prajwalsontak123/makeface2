import 'package:flutter/material.dart';

class FollowersFollowingPage extends StatefulWidget {
  @override
  _FollowersFollowingPageState createState() => _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends State<FollowersFollowingPage> {
  // Placeholder list of followers and following
  List<String> followers = List.generate(10, (index) => 'Follower $index');
  List<String> following = List.generate(15, (index) => 'Following $index');

  Set<String> followingUsers =
      {}; // Set to store the users the current user is following

  // Function to toggle follow/unfollow status
  void toggleFollow(String user) {
    setState(() {
      if (followingUsers.contains(user)) {
        followingUsers.remove(user); // Unfollow
      } else {
        followingUsers.add(user); // Follow
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers and Following'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Followers',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final follower = followers[index];
                final isFollowing = followingUsers.contains(follower);
                return ListTile(
                  title: Text(follower),
                  trailing: TextButton(
                    onPressed: () => toggleFollow(follower),
                    child: Text(isFollowing
                        ? 'Unfollow'
                        : 'Follow'), // Toggle button text based on follow/unfollow status
                  ),
                  onTap: () {
                    // Placeholder for action when tapping on follower
                    print('Tapped on follower: $follower');
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Following',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: following.length,
              itemBuilder: (context, index) {
                final followed = following[index];
                final isFollowing = followingUsers.contains(followed);
                return ListTile(
                  title: Text(followed),
                  trailing: TextButton(
                    onPressed: () => toggleFollow(followed),
                    child: Text(isFollowing
                        ? 'Unfollow'
                        : 'Follow'), // Toggle button text based on follow/unfollow status
                  ),
                  onTap: () {
                    // Placeholder for action when tapping on followed user
                    print('Tapped on followed user: $followed');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
