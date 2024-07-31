import 'package:flutter/material.dart';
import 'dart:async';

class Calling extends StatefulWidget {
  final String calleeName;
  final String calleeImage;

  Calling({required this.calleeName, required this.calleeImage});

  @override
  _CallingState createState() => _CallingState();
}

class _CallingState extends State<Calling> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  String _callStatus = 'Calling...';
  late Timer _callTimer;
  int _callDuration = 0;

  @override
  void initState() {
    super.initState();
    // Simulate call connecting after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _callStatus = 'Connected';
        });
        _startCallTimer();
      }
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _callDuration++;
        });
      }
    });
  }

  String _formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _callTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(widget.calleeImage),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.calleeName,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _callStatus == 'Connected'
                        ? _formatDuration(_callDuration)
                        : _callStatus,
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                    color: Colors.white,
                    iconSize: 36,
                    onPressed: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.red,
                    iconSize: 60,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(_isSpeakerOn ? Icons.volume_up : Icons.volume_down),
                    color: Colors.white,
                    iconSize: 36,
                    onPressed: () {
                      setState(() {
                        _isSpeakerOn = !_isSpeakerOn;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}