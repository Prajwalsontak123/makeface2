import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSearchBar extends StatefulWidget {
  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
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
        .where('username', isLessThan: query.toLowerCase() + 'z')
        .get();

    setState(() {
      _searchResults = querySnapshot.docs
          .map((doc) => doc.get('username').toString())
          .toList();
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
                        return ListTile(
                          title: Text(_searchResults[index]),
                          onTap: () {
                            _searchController.text = _searchResults[index];
                            _saveRecentSearch(_searchResults[index]);
                            setState(() {
                              _searchResults.clear();
                              _searchResults.add(_searchResults[index]);
                            });
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
                  // Save recent search only when a suggestion is tapped
                  _saveRecentSearch(item);
                  // Clear the search results list
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
          .where('username',
              isGreaterThanOrEqualTo: _searchController.text.toLowerCase())
          .where('username',
              isLessThan: _searchController.text.toLowerCase() + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final usernames = snapshot.data!.docs
            .map((doc) => doc.get('username').toString())
            .toList();

        return ListView.builder(
          itemCount: usernames.length,
          itemBuilder: (context, index) {
            return CustomListTile(
              suggestion: usernames[index],
              onTap: () {
                _searchController.text = usernames[index];
                setState(() {
                  _searchResults.clear();
                  _searchResults.add(usernames[index]);
                });
                // Save recent search only when a suggestion is tapped
                _saveRecentSearch(usernames[index]); // Moved here
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
        child: Text(suggestion[0].toUpperCase()),
      ),
      title: Text(suggestion),
      onTap: onTap,
    );
  }
}
