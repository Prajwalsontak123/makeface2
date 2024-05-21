import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  List<String> _suggestions = [
    'apple',
    'banana',
    'orange',
    'grape',
    'pineapple'
  ]; // Example suggestions

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
              // Filter search results based on input value
              _searchResults = _getSearchResults(value);
            });
          },
        ),
      ),
      body: _searchResults.isEmpty && _searchController.text.isNotEmpty
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
    );
  }

  List<String> _getSearchResults(String query) {
    // Mocked function to return search results
    // In a real app, you would fetch data from a server or a local database
    List<String> results = [];
    if (query.isNotEmpty) {
      // Here you would fetch results based on the query
      // For demonstration, I'm just filtering suggestions
      results = _suggestions
          .where((suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return results;
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_suggestions[index]),
          onTap: () {
            _searchController.text = _suggestions[index];
            setState(() {
              _searchResults.clear();
              _searchResults.add(_suggestions[index]);
            });
          },
        );
      },
    );
  }
}
