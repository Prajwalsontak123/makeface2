import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import './screens/call_service.dart';
import './screens/login_screen.dart';
import './screens/incoming_call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _listenForIncomingCalls();
  }

  void _listenForIncomingCalls() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        final incomingCallStream = CallService.getIncomingCallStream();
        if (incomingCallStream != null) {
          incomingCallStream.listen((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              final call = snapshot.docs.first;
              _showIncomingCallScreen(call);
            }
          });
        } else {
          print("No incoming call stream available");
        }
      }
    });
  }

  void _showIncomingCallScreen(DocumentSnapshot call) {
    final callData = call.data() as Map<String, dynamic>;

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => IncomingCallScreen(
          callId: call.id,
          callerName: callData['callerName'] ?? 'Unknown',
          callerProfileImage: callData['callerProfileImage'] ?? '',
          isVideo: callData['isVideo'] ?? false,
          otherUserId: callData['caller'] ?? '', callerId: '', channelName: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makeface',
      navigatorKey: navigatorKey,
      home: LoginPage(),
      builder: (context, child) {
        return Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: child,
              ),
            );
          },
        );
      },
    );
  }
}