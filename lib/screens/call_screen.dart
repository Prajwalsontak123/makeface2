import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call_service.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String otherUserId;
  final String otherUserName;
  final String otherUserProfileImage;
  final bool isVideo;
  final String callId;

  const CallScreen({
    Key? key,
    required this.channelName,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserProfileImage,
    required this.isVideo,
    required this.callId,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  static const appId = "YOUR_APP_ID"; // Replace with your Agora App ID
  late RtcEngine _engine;
  bool _localUserJoined = false;
  bool _remoteUserJoined = false;
  bool _muted = false;
  bool _speakerOn = true;
  int? _remoteUid;
  StreamSubscription? _callStatusSubscription;

  @override
  void initState() {
    super.initState();
    _callStatusSubscription = CallService.callStatusStream(widget.callId).listen((status) {
      if (status == CallService.CALL_STATE_ENDED) {
        _onCallEnd();
      }
    });
    initAgora();
  }

  Future<String?> _getAgoraToken() async {
    try {
      // Implement proper token fetching here
      // For example, make an API call to your server to get the token
      // final response = await http.get(Uri.parse('your_token_server_url'));
      // return response.body;
      
      // For testing, return a temporary token:
      return "006YOUR_TEMPORARY_TOKEN_HERE";
    } catch (e) {
      print("Error fetching Agora token: $e");
      return null;
    }
  }

  Future<void> initAgora() async {
    try {
      await [Permission.microphone, Permission.camera].request();

      _engine = createAgoraRtcEngine();
      await _engine.initialize(RtcEngineContext(appId: appId));

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print("Local user joined the channel");
            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print("Remote user joined: $remoteUid");
            setState(() {
              _remoteUserJoined = true;
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            print("Remote user offline: $remoteUid, reason: $reason");
            setState(() {
              _remoteUserJoined = false;
              _remoteUid = null;
            });
          },
          onError: (ErrorCodeType err, String msg) {
            print("Agora error: $err - $msg");
          },
        ),
      );

      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine.enableAudio();
      if (widget.isVideo) {
        await _engine.enableVideo();
      }

      // Update call status to 'answered' when joining the channel
      await CallService.updateCallStatus(widget.callId, CallService.CALL_STATE_ANSWERED);

      String? token = await _getAgoraToken();
      if (token == null) {
        print("Error: Unable to get Agora token");
        return;
      }

      print("Joining channel: ${widget.channelName} with token: $token");
      await _engine.joinChannel(
        token: token,
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      print("Error initializing Agora: $e");
    }
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    _callStatusSubscription?.cancel();
    super.dispose();
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleSpeaker() {
    setState(() {
      _speakerOn = !_speakerOn;
    });
    _engine.setEnableSpeakerphone(_speakerOn);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onCallEnd() async {
    await CallService.endCall(widget.callId);
    _engine.leaveChannel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.teal.shade700, Colors.teal.shade900],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.otherUserProfileImage),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.otherUserName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _remoteUserJoined ? "Connected" : "Calling...",
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
                      IconButton(
                        icon: Icon(_muted ? Icons.mic_off : Icons.mic),
                        onPressed: _onToggleMute,
                        color: Colors.white,
                        iconSize: 36,
                      ),
                      IconButton(
                        icon: const Icon(Icons.call_end),
                        onPressed: _onCallEnd,
                        color: Colors.red,
                        iconSize: 48,
                      ),
                      IconButton(
                        icon: Icon(_speakerOn ? Icons.volume_up : Icons.volume_off),
                        onPressed: _onToggleSpeaker,
                        color: Colors.white,
                        iconSize: 36,
                      ),
                      if (widget.isVideo)
                        IconButton(
                          icon: const Icon(Icons.switch_camera),
                          onPressed: _onSwitchCamera,
                          color: Colors.white,
                          iconSize: 36,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.isVideo) ...[
            if (_localUserJoined)
              AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            if (_remoteUserJoined)
              AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine,
                  canvas: VideoCanvas(uid: _remoteUid),
                  connection: RtcConnection(channelId: widget.channelName),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
