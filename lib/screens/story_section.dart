import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:makeface2/screens/shared_preferences_service.dart';
import 'package:makeface2/screens/story_creation_page.dart';
import 'package:makeface2/screens/story_viewing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorySection extends StatefulWidget {
  final bool userHasStory;

  StorySection({this.userHasStory = false});

  @override
  _StorySectionState createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  List<String> storyUrls = [];
  Map<int, bool> viewedStories = {};
  bool _allStoriesViewed = false;
  bool _firstCircleYellow = false;

  @override
  void initState() {
    super.initState();
    _loadStories();
    _loadViewedStories();
  }

  Future<void> _loadStories() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('loggedin_users')
              .doc(user.uid)
              .get();

      if (!userSnapshot.exists) {
        throw Exception('User data not found');
      }

      String uniqueName = userSnapshot.data()?['unique_name'] ?? '';
      if (uniqueName.isEmpty) {
        throw Exception('Unique name not found');
      }

      ListResult result = await FirebaseStorage.instance
          .ref()
          .child('stories/$uniqueName')
          .listAll();

      List<String> urls = [];
      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        urls.add(downloadUrl);
      }

      setState(() {
        storyUrls = urls;
      });
    } catch (e) {
      print('Error loading stories from Firebase Storage: $e');
    }
  }

  Future<void> _loadViewedStories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      viewedStories.clear();
      for (int i = 0; i < storyUrls.length; i++) {
        viewedStories[i] = prefs.getBool('story_$i') ?? false;
      }
    });
  }

  void _viewStory(int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewingPage(storyIndex: index),
      ),
    ).then((_) async {
      await _loadViewedStories();
      setState(() {
        viewedStories.update(index, (value) => true, ifAbsent: () => true);
        SharedPreferencesService.markStoryAsViewed(index);
      });
    });
  }

  Future<bool> hasStory(String userId) async {
    final storageRef = FirebaseStorage.instance.ref();
    final storyRef = storageRef.child('stories/$userId');

    try {
      final ListResult result = await storyRef.listAll();
      return result.items.isNotEmpty;
    } catch (e) {
      print('Error checking for story: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storyUrls.length + 1,
        itemBuilder: (BuildContext context, int index) {
          bool hasActiveStory =
              index < storyUrls.length || (index == 0 && widget.userHasStory);
          bool isViewed = viewedStories[index] ?? false;

          return GestureDetector(
            onTap: () {
              if (index == 0) {
                if (hasActiveStory) {
                  _viewStory(index);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryCreationPage(),
                    ),
                  );
                }
              } else {
                // Dummy story icons do nothing on tap
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Stack(
                children: [
                  if (hasActiveStory && !isViewed && index == 0)
                    Positioned.fill(
                      child: AnimatedGradientCircle(
                        allStoriesViewed: _allStoriesViewed,
                        firstCircleYellow: _firstCircleYellow,
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: index == 0 && hasActiveStory
                          ? _firstCircleYellow
                              ? LinearGradient(
                                  colors: [Colors.yellow, Colors.yellow],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 42, 64, 188),
                                    Colors.pink,
                                    Colors.orange
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 38.0,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 36.0,
                        backgroundColor:
                            const Color.fromARGB(255, 173, 175, 177),
                        child: index == 0 && !hasActiveStory
                            ? SizedBox.shrink()
                            : Text(
                                '${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      bottom: 27,
                      right: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryCreationPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedGradientCircle extends StatefulWidget {
  final bool allStoriesViewed;
  final bool firstCircleYellow;

  AnimatedGradientCircle({
    required this.allStoriesViewed,
    required this.firstCircleYellow,
  });

  @override
  _AnimatedGradientCircleState createState() => _AnimatedGradientCircleState();
}

class _AnimatedGradientCircleState extends State<AnimatedGradientCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedGradientCircle oldWidget) {
    if (widget.allStoriesViewed || widget.firstCircleYellow) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GradientCirclePainter(_controller.value),
          child: SizedBox(
            width: 90,
            height: 90,
          ),
        );
      },
    );
  }
}

class GradientCirclePainter extends CustomPainter {
  final double animationValue;

  GradientCirclePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final gradient = SweepGradient(
      colors: [
        Colors.blue,
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.blue
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(animationValue * 2 * 3.1415926535897932),
    );
    final paint = Paint()
      ..shader = gradient.createShader(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius));

    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
