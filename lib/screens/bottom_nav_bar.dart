import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'anime_chat.dart';
import 'home_screen.dart';
import 'circle_profile.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false, // Hide labels for selected item
      showUnselectedLabels: false, // Hide labels for unselected items
      selectedIconTheme: IconThemeData(
        color: Colors.black,
      ), // Set the selected icon color to black
      unselectedIconTheme: IconThemeData(
        color: Colors.black,
      ), // Set the unselected icon color to black
      currentIndex: currentIndex, // Set the current index
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_reaction_outlined),
          label: 'Incognito Mode',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trip_origin_outlined),
          label: 'Circle',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User Profile',
        ),
      ],
    );
  }
}

void showAddPostOptions(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Choose Files'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add_a_photo),
              title: Text('Camera'),
              onTap: () {
                openCamera(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text('Local Storage'),
              onTap: () {
                openGallery(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void openCamera(BuildContext context) async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
  Navigator.pop(context); // Close the dialog
  // Handle the picked file as needed
  if (pickedFile != null) {
    // Do something with the picked image
  }
}

void openGallery(BuildContext context) async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  Navigator.pop(context); // Close the dialog
  // Handle the picked file as needed
  if (pickedFile != null) {
    // Do something with the picked image
  }
}
