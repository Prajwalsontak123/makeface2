import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class StoryCreationPage extends StatefulWidget {
  @override
  _StoryCreationPageState createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  List<AssetEntity> _assets = [];
  String _selectedOption = 'Recents';
  int _currentPage = 0;
  final int _pageSize = 100;
  bool _hasMoreAssets = true;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth) {
        final albums = await PhotoManager.getAssetPathList(onlyAll: true);
        if (albums.isNotEmpty) {
          final recentAlbum = albums.first;
          final assets = await recentAlbum.getAssetListRange(
            start: _currentPage * _pageSize,
            end: (_currentPage + 1) * _pageSize,
          );

          setState(() {
            _assets.addAll(assets);
            _currentPage++;
            _hasMoreAssets = assets.length == _pageSize;
          });
          print('Number of assets loaded: ${_assets.length}');
        } else {
          print('No albums found');
        }
      } else {
        print('Permission denied');
      }
    } catch (e) {
      print('Error loading assets: $e');
    }
  }

  Future<void> _loadMoreAssets() async {
    if (!_hasMoreAssets) return;

    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    if (albums.isNotEmpty) {
      final recentAlbum = albums.first;
      final assets = await recentAlbum.getAssetListRange(
        start: _currentPage * _pageSize,
        end: (_currentPage + 1) * _pageSize,
      );

      setState(() {
        _assets.addAll(assets);
        _currentPage++;
        _hasMoreAssets = assets.length == _pageSize;
      });
    }
  }

  void _selectAsset(AssetEntity asset) {
    // Implement the functionality to select an asset
    print('Selected asset ID: ${asset.id}');
    // Navigate to editing page or perform another action
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add to story', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Implement settings functionality
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOptionButton(Icons.camera_alt, 'Camera'),
                _buildOptionButton(Icons.grid_4x4, 'Drafts'),
                _buildOptionButton(Icons.photo, 'Photos'),
                _buildOptionButton(Icons.play_circle_outline, 'Videos'),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedOption,
                  dropdownColor: Colors.black,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                  items: <String>['Recents', 'Last Week', 'Last Month']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextButton(
                  child: Text('Select',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Implement select functionality
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: _assets.length,
              itemBuilder: (context, index) {
                if (index == _assets.length - 1 && _hasMoreAssets) {
                  _loadMoreAssets();
                }
                return GestureDetector(
                  onTap: () => _selectAsset(_assets[index]),
                  child: FutureBuilder<Uint8List?>(
                    future: _assets[index].thumbnailData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                            if (_assets[index].type == AssetType.video)
                              Positioned(
                                right: 5,
                                bottom: 5,
                                child: Icon(Icons.play_circle_outline,
                                    color: Colors.white, size: 24),
                              ),
                          ],
                        );
                      } else {
                        return Container(color: Colors.grey[800]);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
