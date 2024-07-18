import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_player/video_player.dart';

class StoryViewingPage extends StatefulWidget {
  final int storyIndex;

  StoryViewingPage({required this.storyIndex});

  @override
  _StoryViewingPageState createState() => _StoryViewingPageState();
}

class _StoryViewingPageState extends State<StoryViewingPage> {
  List<String> storyUrls = [];
  int currentStoryIndex = 0;
  String username = '';
  String profileUrl = '';
  String timeAgo = '';
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _fetchStoryData();
  }

  Future<void> _fetchStoryData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('loggedin_users')
              .doc(user.uid)
              .get();

      if (!userSnapshot.exists) throw Exception('User data not found');

      String uniqueName = userSnapshot.data()?['unique_name'] ?? '';
      if (uniqueName.isEmpty) throw Exception('Unique name not found');

      setState(() {
        username = uniqueName;
        profileUrl = userSnapshot.data()?['profile_picture'] ?? '';
        timeAgo = '1m'; // Calculate this based on the story timestamp
      });

      Reference storageRef =
          FirebaseStorage.instance.ref().child('stories/$uniqueName');
      ListResult result = await storageRef.listAll();

      List<String> urls = [];
      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        urls.add(downloadUrl);
      }

      setState(() {
        storyUrls = urls;
        currentStoryIndex = widget.storyIndex;
      });

      if (storyUrls.isNotEmpty) {
        _loadStory(widget.storyIndex);
      }
    } catch (e) {
      print('Error fetching story data: $e');
    }
  }

  void _loadStory(int index) {
    if (index < 0 || index >= storyUrls.length) return;

    setState(() {
      currentStoryIndex = index;
    });

    if (storyUrls[index].contains('.mp4')) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(storyUrls[index])
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
    }

    // Mark story as viewed if needed
    // This is where you can implement logic to mark stories as viewed
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: storyUrls.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTapDown: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx < screenWidth / 2) {
                  _loadStory(currentStoryIndex - 1);
                } else {
                  _loadStory(currentStoryIndex + 1);
                }
              },
              child: Stack(
                children: [
                  // Story Content
                  Positioned.fill(
                    child: _buildStoryContent(),
                  ),
                  // Top Section
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        // Progress Bars
                        Row(
                          children: List.generate(
                            storyUrls.length,
                            (index) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: LinearPercentIndicator(
                                  lineHeight: 2.0,
                                  percent: index <= currentStoryIndex ? 1 : 0,
                                  backgroundColor: Colors.grey,
                                  progressColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  CachedNetworkImageProvider(profileUrl),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Bottom Actions
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(Icons.add, 'Create'),
                        _buildActionButton(Icons.favorite, 'Highlight'),
                        _buildActionButton(Icons.send, 'Send'),
                        _buildActionButton(Icons.more_vert, 'More'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStoryContent() {
    if (storyUrls[currentStoryIndex].contains('.mp4')) {
      return _videoController?.value.isInitialized ?? false
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : Center(child: CircularProgressIndicator());
    } else {
      return CachedNetworkImage(
        imageUrl: storyUrls[currentStoryIndex],
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      );
    }
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
