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
      height: 100.0,
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
                      Container(
                        padding: EdgeInsets.all(3),
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
                          radius: 32.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 30.0,
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
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
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
