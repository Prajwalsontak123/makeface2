import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:makeface2/screens/story_creation_page.dart';

class StorySection extends StatelessWidget {
  final bool userHasStory;

  StorySection({this.userHasStory = false});

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
      height:
          120.0, // Increase the height of the container to accommodate larger avatars
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<bool>(
            future: index == 0
                ? Future.value(userHasStory)
                : hasStory('user_$index'),
            builder: (context, snapshot) {
              bool hasActiveStory = snapshot.data ?? false;
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoryCreationPage()),
                    );
                  } else {
                    // Handle story viewing
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Stack(
                    children: [
                      if (hasActiveStory)
                        Positioned.fill(
                          child:
                              AnimatedGradientCircle(), // Use AnimatedGradientCircle here
                        ),
                      Container(
                        padding: EdgeInsets.all(
                            4), // Adjust padding for larger circle
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: hasActiveStory
                              ? LinearGradient(
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
                          radius:
                              38.0, // Increase the radius of the outer circle
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius:
                                36.0, // Increase the radius of the inner circle
                            backgroundColor: index == 0
                                ? Colors.blue
                                : const Color.fromARGB(255, 173, 175, 177),
                            child: index == 0
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
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(
                                3), // Adjust padding for larger add icon
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22, // Increase the size of the add icon
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AnimatedGradientCircle extends StatefulWidget {
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GradientCirclePainter(_controller.value),
          child: SizedBox(
            width: 90,
            height: 90,
          ), // Increase the size of the custom paint area
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
