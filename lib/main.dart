import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/login_screen.dart'; // Ensure the path to LoginPage is correct
import 'firebase_options.dart'; // Ensure the firebase_options.dart file is generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makeface',
      home: LoginPage(), // Set LoginPage as the initial screen
    );
  }
}
