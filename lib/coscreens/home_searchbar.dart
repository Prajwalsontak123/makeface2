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
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', _searchHistory);
  }

  void _addToSearchHistory(String searchTerm) {
    if (!_searchHistory.contains(searchTerm)) {
      setState(() {
        _searchHistory.insert(0, searchTerm);
      });
      _saveSearchHistory();
    }
  }

  void _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('searchHistory');
    setState(() {
      _searchHistory.clear();
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
                _addToSearchHistory(value);
              }
              _getSearchResults(value);
            });
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _searchResults.isEmpty && _searchController.text.isNotEmpty
                ? _buildSuggestionsList()
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_searchResults[index]),
                        onTap: () {
                          // Handle tapping on search result
                          // For example, navigate to a detailed page
                        },
                      );
                    },
                  ),
          ),
          if (_searchHistory
              .isNotEmpty) // Only show search history if there are items
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchHistory.length,
                    itemBuilder: (context, index) {
                      return SearchHistoryTile(
                        searchTerm: _searchHistory[index],
                        onTap: () {
                          setState(() {
                            _searchController.text = _searchHistory[index];
                            _getSearchResults(_searchHistory[index]);
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                });
                _clearSearchHistory();
              },
              child: Text('Clear Search'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getSearchResults(String query) async {
    if (query.isNotEmpty) {
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
                  _addToSearchHistory(usernames[index]);
                });
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

class SearchHistoryTile extends StatelessWidget {
  final String searchTerm;
  final VoidCallback onTap;

  const SearchHistoryTile({required this.searchTerm, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(searchTerm[0].toUpperCase()),
      ),
      title: Text(searchTerm),
      onTap: onTap,
    );
  }
}
