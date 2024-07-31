import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottom_nav_bar.dart';
import 'home_screen.dart';
import 'circle_screen.dart';
import 'open_homechat.dart';
import 'profile_home.dart';

class HomeChat extends StatefulWidget {
  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _recentChats = [];
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;
  late String _currentUserId;
  List<String> _supportingAndFans = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Current user ID: ${user.uid}");
      _currentUserId = user.uid;
      await _fetchSupportingAndFans();
      await _fetchRecentChats();
    } else {
      print("No user logged in");
    }
  }

  Future<void> _fetchSupportingAndFans() async {
    print("Fetching supporting and fans");
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('loggedin_users')
        .doc(_currentUserId)
        .get();

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    List<String> supporting = List<String>.from(userData['supporting'] ?? []);
    List<String> fans = List<String>.from(userData['fans'] ?? []);
    
    print("Supporting: $supporting");
    print("Fans: $fans");

    setState(() {
      _supportingAndFans = [...supporting, ...fans];
    });
    
    print("Total supporting and fans: ${_supportingAndFans.length}");
  }

  Future<void> _fetchRecentChats() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: _currentUserId)
        .orderBy('lastMessageTimestamp', descending: true)
        .limit(20)
        .get();

    setState(() {
      _recentChats = querySnapshot.docs;
    });
    print("Fetched ${_recentChats.length} recent chats");
  }

  void _performSearch(String searchTerm) async {
    print("Performing search for: $searchTerm");
    
    if (searchTerm.isEmpty) {
      print("Search term is empty, clearing results");
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    if (_supportingAndFans.isEmpty) {
      print("No supporting or fans, clearing results");
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    print("Querying Firestore for: $_supportingAndFans");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('loggedin_users')
        .where(Filter.or(
          Filter('unique_name', whereIn: _supportingAndFans),
          Filter('username', whereIn: _supportingAndFans),
        ))
        .get();

    print("Query returned ${querySnapshot.docs.length} results");

    List<DocumentSnapshot> filteredResults = querySnapshot.docs.where((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String uniqueName = data['unique_name']?.toString().toLowerCase() ?? '';
      String username = data['username']?.toString().toLowerCase() ?? '';
      String lowercaseSearchTerm = searchTerm.toLowerCase();
      return uniqueName.contains(lowercaseSearchTerm) || username.contains(lowercaseSearchTerm);
    }).toList();

    print("Filtered results: ${filteredResults.length}");

    setState(() {
      _searchResults = filteredResults;
      _isSearching = false;
    });
    
    print("Search completed, results set");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement new message functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by username or @unique_name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                // Debounce the search to prevent too frequent updates
                Future.delayed(Duration(milliseconds: 300), () {
                  if (value == _searchController.text) {
                    _performSearch(value);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: _isSearching 
                ? Center(child: CircularProgressIndicator())
                : (_searchResults.isNotEmpty ? _buildSearchResults() : _buildRecentChats()),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              // Do nothing, already in HomeChat
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CircleScreen()),
              );
              break;
            case 3:
              showAddPostOptions(context);
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileHome()),
              );
              break;
          }
        },
      ),
    );
  }

 // In HomeChat widget, update the _buildSearchResults method:

Widget _buildSearchResults() {
  return ListView.builder(
    itemCount: _searchResults.length,
    itemBuilder: (context, index) {
      final userData = _searchResults[index].data() as Map<String, dynamic>;
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(userData['profile_image'] ?? ''),
        ),
        title: Text(userData['username'] ?? userData['unique_name']),
        subtitle: Text('@${userData['unique_name']}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OpenHomeChat(
                otherUserId: _searchResults[index].id,
                otherUserName: userData['username'] ?? userData['unique_name'],
                otherUserProfileImage: userData['profile_image'] ?? '',
              ),
            ),
          );
        },
      );
    },
  );
}

  Widget _buildRecentChats() {
    if (_recentChats.isEmpty) {
      return Center(child: Text('No recent chats.'));
    }

    return ListView.builder(
      itemCount: _recentChats.length,
      itemBuilder: (context, index) {
        final chatData = _recentChats[index].data() as Map<String, dynamic>;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(chatData['otherUserProfileImage'] ?? ''),
          ),
          title: Text(chatData['otherUserName'] ?? ''),
          subtitle: Text(chatData['lastMessage'] ?? ''),
          trailing: Text(
            _formatTimestamp(chatData['lastMessageTimestamp'] as Timestamp),
          ),
          onTap: () {
            // TODO: Navigate to chat screen with this user
          },
        );
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    // TODO: Implement proper timestamp formatting
    return timestamp.toDate().toString();
  }
}

void showAddPostOptions(BuildContext context) {
  // TODO: Implement the showAddPostOptions function
}