import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeface2/screens/view_notification.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String username;
  final String profileImage;
  final String bio;
  final String otherUserUniqueName;

  const OtherUserProfileScreen({
    required this.username,
    required this.profileImage,
    required this.bio,
    required this.otherUserUniqueName,
  });

  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  bool isSupporting = false;
  late String currentUserUniqueName;
  late String currentUserId;
  int fansCount = 0;
  int supportingCount = 0;

  @override
  void initState() {
    super.initState();
    checkIfSupporting();
    fetchCounts();
  }

  Future<void> checkIfSupporting() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('loggedin_users')
          .doc(user.uid)
          .get();

      currentUserUniqueName = currentUserSnapshot['unique_name'];
      currentUserId = user.uid;

      List supportingList = currentUserSnapshot['supporting'] ?? [];
      if (supportingList.contains(widget.otherUserUniqueName)) {
        setState(() {
          isSupporting = true;
        });
      }
    }
  }

  Future<void> fetchCounts() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('loggedin_users')
            .where('unique_name', isEqualTo: widget.otherUserUniqueName)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference otherUserRef = querySnapshot.docs.first.reference;
          DocumentSnapshot otherUserSnapshot = await otherUserRef.get();

          // Ensure the fields exist
          Map<String, dynamic> data =
              otherUserSnapshot.data() as Map<String, dynamic>;

          // Check if the fields exist, if not initialize them
          if (!data.containsKey('fans') || !data.containsKey('supporting')) {
            await FirebaseFirestore.instance
                .collection('loggedin_users')
                .doc(otherUserRef.id)
                .set({
              'fans': [],
              'supporting': [],
            }, SetOptions(merge: true));
          }

          // After ensuring the fields are initialized, fetch the counts
          DocumentSnapshot updatedSnapshot = await otherUserRef.get();
          List fansList = updatedSnapshot['fans'] ?? [];
          List supportingList = updatedSnapshot['supporting'] ?? [];

          setState(() {
            fansCount = fansList.length;
            supportingCount = supportingList.length;
          });
        } else {
          throw Exception("Other user not found");
        }
      } catch (e) {
        print('Error fetching counts: $e');
      }
    }
  }

  Future<void> toggleSupport() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference currentUserRef =
          FirebaseFirestore.instance.collection('loggedin_users').doc(user.uid);

      DocumentReference otherUserRef = await FirebaseFirestore.instance
          .collection('loggedin_users')
          .where('unique_name', isEqualTo: widget.otherUserUniqueName)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.reference;
        } else {
          throw Exception("Other user not found");
        }
      });

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot currentUserSnapshot =
            await transaction.get(currentUserRef);
        DocumentSnapshot otherUserSnapshot =
            await transaction.get(otherUserRef);

        List currentUserSupporting =
            List.from(currentUserSnapshot['supporting'] ?? []);
        List otherUserFans = List.from(otherUserSnapshot['fans'] ?? []);

        if (isSupporting) {
          currentUserSupporting.remove(widget.otherUserUniqueName);
          otherUserFans.remove(currentUserUniqueName);
        } else {
          currentUserSupporting.add(widget.otherUserUniqueName);
          otherUserFans.add(currentUserUniqueName);
        }

        transaction
            .update(currentUserRef, {'supporting': currentUserSupporting});
        transaction.update(otherUserRef, {'fans': otherUserFans});
      });

      // Create notification for both users
      await createNotification(isSupporting);

      setState(() {
        isSupporting = !isSupporting;
        fetchCounts();
      });
    }
  }

  Future<void> createNotification(bool isStartedSupporting) async {
    // Notification for current user
    await FirebaseFirestore.instance.collection('notifications').add({
      'to_unique_name': widget.otherUserUniqueName,
      'from_unique_name': currentUserUniqueName,
      'type': isStartedSupporting ? 'started_supporting' : 'stopped_supporting',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Notification for the other user
    await FirebaseFirestore.instance.collection('notifications').add({
      'to_unique_name': currentUserUniqueName,
      'from_unique_name': widget.otherUserUniqueName,
      'type': isStartedSupporting ? 'started_supporting' : 'stopped_supporting',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.username),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () {
                // Navigate to NotificationScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewNotificationPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(widget.profileImage),
              _buildProfileDetails(widget.username, widget.bio),
              _buildSupportButton(),
              _buildTabBar(),
              _buildTabView(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildProfileHeader(String profileImage) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: CachedNetworkImageProvider(profileImage),
          ),
          Column(
            children: [
              Text(
                '$supportingCount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Supporting'),
            ],
          ),
          Column(
            children: [
              Text(
                '$fansCount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Fans'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(String username, String bio) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(bio),
          SizedBox(height: 4),
          Text('Link goes here', style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildSupportButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: toggleSupport,
        child: Text(isSupporting ? 'Supporting' : 'Support'),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      tabs: [
        Tab(icon: Icon(Icons.grid_on)),
        Tab(icon: Icon(Icons.video_library)),
        Tab(icon: Icon(Icons.person_pin)),
      ],
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
    );
  }

  Widget _buildTabView() {
    return Container(
      height: 400,
      child: TabBarView(
        children: [
          _buildGrid(),
          Center(child: Text('IGTV Videos')),
          Center(child: Text('Tagged Posts')),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 30,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: 'https://via.placeholder.com/150',
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
