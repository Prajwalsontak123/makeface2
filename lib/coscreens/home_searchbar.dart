import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makeface2/screens/otheruser_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the file from the 'coscreens' folder

class HomeSearchBar extends StatefulWidget {
  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String searchTerm) async {
    final prefs = await SharedPreferences.getInstance();
    if (_recentSearches.contains(searchTerm)) {
      _recentSearches.remove(searchTerm);
    }
    _recentSearches.insert(0, searchTerm);
    if (_recentSearches.length > 10) {
      _recentSearches =
          _recentSearches.sublist(0, 10); // Limit to 10 recent searches
    }
    await prefs.setStringList('recentSearches', _recentSearches);
  }

  void _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
    setState(() {
      _recentSearches.clear();
    });
  }

  Future<void> _deleteRecentSearch(String searchTerm) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.remove(searchTerm);
    });
    await prefs.setStringList('recentSearches', _recentSearches);
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      _getSearchResults(query);
    }
  }

  Future<void> _getSearchResults(String query) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('loggedin_users')
        .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('username', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
        .get();

    setState(() {
      _searchResults = querySnapshot.docs.map((doc) {
        return {
          'username': doc.get('username').toString(),
          'profile_image':
              doc.get('profile_image') ?? 'https://via.placeholder.com/150',
          'bio': doc.get('bio') ?? '', // Assuming you have a bio field
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                });
              },
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _performSearch(value);
            } else {
              setState(() {
                _searchResults.clear();
              });
            }
          },
        ),
      ),
      body: Column(
        children: [
          if (_searchController.text.isEmpty)
            Expanded(child: _buildRecentSearchesList())
          else
            Expanded(
              child: _searchResults.isEmpty
                  ? _buildSuggestionsList()
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_searchResults[index]['username']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              _searchResults[index]['profile_image'],
                            ),
                            onBackgroundImageError: (_, __) {
                              setState(() {
                                _searchResults[index]['profile_image'] =
                                    'https://via.placeholder.com/150';
                              });
                            },
                          ),
                          onTap: () {
                            _searchController.text =
                                _searchResults[index]['username'];
                            _saveRecentSearch(
                                _searchResults[index]['username']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtherUserProfileScreen(
                                  username: _searchResults[index]['username'],
                                  profileImage: _searchResults[index]
                                      ['profile_image'],
                                  bio: _searchResults[index]['bio'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              TextButton(
                onPressed: _clearRecentSearches,
                child: Text('Clear All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final item = _recentSearches[index];
              return Dismissible(
                key: Key(item),
                onDismissed: (direction) {
                  _deleteRecentSearch(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$item dismissed')),
                  );
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(item),
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('loggedin_users')
                          .where('username', isEqualTo: item)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          );
                        }

                        final doc = snapshot.data!.docs.first;
                        final profileImage = doc.get('profile_image') ??
                            'https://via.placeholder.com/150';

                        return CircleAvatar(
                          backgroundImage: NetworkImage(profileImage),
                          onBackgroundImageError: (_, __) {
                            // Handle error here
                          },
                        );
                      },
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _deleteRecentSearch(item);
                    },
                  ),
                  onTap: () {
                    _searchController.text = item;
                    _getSearchResults(item);
                    _saveRecentSearch(item);
                    setState(() {
                      _searchResults.clear();
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('loggedin_users')
          .where('username',
              isGreaterThanOrEqualTo: _searchController.text.toLowerCase())
          .where('username',
              isLessThanOrEqualTo:
                  _searchController.text.toLowerCase() + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = snapshot.data!.docs.map((doc) {
          return {
            'username': doc.get('username').toString(),
            'profile_image':
                doc.get('profile_image') ?? 'https://via.placeholder.com/150',
            'bio': doc.get('bio') ?? '', // Assuming you have a bio field
          };
        }).toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return CustomListTile(
              suggestion: users[index]['username'],
              profile_image: users[index]['profile_image'],
              bio: users[index]['bio'], // Pass the bio field
              onTap: () {
                _searchController.text = users[index]['username'];
                setState(() {
                  _searchResults = [users[index]];
                });
                _saveRecentSearch(users[index]['username']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherUserProfileScreen(
                      username: users[index]['username'],
                      profileImage: users[index]['profile_image'],
                      bio: users[index]['bio'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String suggestion;
  final String profile_image;
  final String bio; // Added bio field
  final VoidCallback onTap;

  const CustomListTile({
    required this.suggestion,
    required this.profile_image,
    required this.bio, // Added bio field
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profile_image),
        onBackgroundImageError: (_, __) {
          // Handle error here
        },
      ),
      title: Text(suggestion),
      subtitle: Text(bio), // Display the bio field
      onTap: onTap,
    );
  }
}
