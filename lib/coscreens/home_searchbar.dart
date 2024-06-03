import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';

class HomeSearchBar extends StatefulWidget {
  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _getSearchResults(query);
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  Future<void> _getSearchResults(String query) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('loggedin_users').get();

    List<Map<String, String>> results = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String username = data['username']?.toString() ?? '';
      String uniqueName = data['unique_name']?.toString() ?? '';

      double usernameSimilarity = username.similarityTo(query);
      double uniqueNameSimilarity = uniqueName.similarityTo(query);

      if (usernameSimilarity >= 0.7 || uniqueNameSimilarity >= 0.7) {
        results.add({
          'username': username,
          'unique_name': uniqueName,
        });
      }
    }

    setState(() {
      _searchResults = results;
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
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Search Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                _searchResults[index]['profile_image'] ??
                    'https://via.placeholder.com/150',
              ),
            ),
            title: Text(_searchResults[index]['username']!),
            subtitle: Text(_searchResults[index]['unique_name']!),
            onTap: () {
              // Handle tap on search result
            },
          );
        },
      );
    }
  }
}