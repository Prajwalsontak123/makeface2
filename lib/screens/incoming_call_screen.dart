import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'call_service.dart';
import 'call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerProfileImage;
  final String channelName;
  final bool isVideo;

  const IncomingCallScreen({
    Key? key,
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerProfileImage,
    required this.channelName,
    required this.isVideo, required otherUserId,
  }) : super(key: key);

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  @override
  void initState() {
    super.initState();
    _playRingtone();
  }

  void _playRingtone() {
    FlutterRingtonePlayer.playRingtone();
  }

  void _stopRingtone() {
    FlutterRingtonePlayer.stop();
  }

  Future<void> _answerCall() async {
    _stopRingtone();
    try {
      await CallService.answerCall(widget.callId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            callId: widget.callId,
            channelName: widget.channelName,
            otherUserId: widget.callerId,
            otherUserName: widget.callerName,
            otherUserProfileImage: widget.callerProfileImage,
            isVideo: widget.isVideo,
          ),
        ),
      );
    } catch (e) {
      print("Error answering call: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to answer call: $e")),
      );
    }
  }

  Future<void> _rejectCall() async {
    _stopRingtone();
    try {
      await CallService.rejectCall(widget.callId);
      Navigator.pop(context);
    } catch (e) {
      print("Error rejecting call: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to reject call: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade700, Colors.blue.shade900],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.callerProfileImage),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.callerName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isVideo ? "Incoming Video Call" : "Incoming Audio Call",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: _rejectCall,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.call_end),
                        tooltip: "Reject Call",
                      ),
                      FloatingActionButton(
                        onPressed: _answerCall,
                        backgroundColor: Colors.green,
                        child: Icon(widget.isVideo ? Icons.videocam : Icons.call),
                        tooltip: widget.isVideo ? "Answer Video Call" : "Answer Audio Call",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopRingtone();
    super.dispose();
  }
}