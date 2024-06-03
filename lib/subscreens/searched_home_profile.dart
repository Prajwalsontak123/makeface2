import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'searched_home_profile.dart'; // Ensure this import path is correct

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
      _recentSearches = _recentSearches.sublist(0, 10); // Limit to 10 recent searches
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
    QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
        .collection('loggedin_users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    QuerySnapshot uniqueNameSnapshot = await FirebaseFirestore.instance
        .collection('loggedin_users')
        .where('unique_name', isGreaterThanOrEqualTo: query)
        .where('unique_name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    List<Map<String, dynamic>> usernames = usernameSnapshot.docs
        .map((doc) => {
              'username': (doc.data() as Map<String, dynamic>)['username'],
              'userId': doc.id,
            })
        .toList();

    List<Map<String, dynamic>> uniqueNames = uniqueNameSnapshot.docs
        .map((doc) => {
              'unique_name': (doc.data() as Map<String, dynamic>)['unique_name'],
              'userId': doc.id,
            })
        .toList();

    setState(() {
      _searchResults = [...usernames, ...uniqueNames];
    });
  }

  void _navigateToUserProfile(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchedHomeProfile(userId: userId),
      ),
    );
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
            setState(() {
              _searchResults.clear();
              if (value.isNotEmpty) {
                _performSearch(value);
              }
            });
          },
          onTap: () {
            setState(() {});
          },
        ),
      ),
      body: Column(
        children: [
          if (_searchController.text.isEmpty)
            _buildRecentSearchesList()
          else
            Expanded(
              child: _searchResults.isEmpty
                  ? _buildSuggestionsList()
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        String displayText = _searchResults[index]['username'] ?? _searchResults[index]['unique_name'];
                        String userId = _searchResults[index]['userId'];
                        return ListTile(
                          title: Text(displayText),
                          onTap: () {
                            _searchController.text = displayText;
                            _saveRecentSearch(displayText);
                            setState(() {
                              _searchResults.clear();
                            });
                            _navigateToUserProfile(userId);
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
        ListView.builder(
          shrinkWrap: true,
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
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('loggedin_users')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = snapshot.data!.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          String? username = data.containsKey('username') ? data['username'].toString() : null;
          String? uniqueName = data.containsKey('unique_name') ? data['unique_name'].toString() : null;
          return {'username': username, 'unique_name': uniqueName, 'userId': doc.id};
        }).where((user) => user['username'] != null || user['unique_name'] != null).toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            String suggestion = users[index]['username'] ?? users[index]['unique_name']!;
            return CustomListTile(
              suggestion: suggestion,
              onTap: () {
                _searchController.text = suggestion;
                setState(() {
                  _searchResults.clear();
                  _searchResults.add(users[index]);
                });
                _saveRecentSearch(suggestion);
                _navigateToUserProfile(users[index]['userId']);
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
  final VoidCallback onTap;

  const CustomListTile({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: suggestion.isNotEmpty
            ? Text(suggestion[0].toUpperCase())
            : Icon(Icons.person),
      ),
      title: Text(suggestion),
      onTap: onTap,
    );
  }
}
