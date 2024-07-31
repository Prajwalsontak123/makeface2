import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'call_service.dart';
import 'call_screen.dart';

class OpenHomeChat extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String otherUserProfileImage;

  const OpenHomeChat({
    Key? key,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserProfileImage,
  }) : super(key: key);

  @override
  _OpenHomeChatState createState() => _OpenHomeChatState();
}

class _OpenHomeChatState extends State<OpenHomeChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _currentUserId;
  late Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _setupMessagesStream();
  }

  void _setupMessagesStream() {
    _messagesStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(_getChatDocumentId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  String _getChatDocumentId() {
    List<String> ids = [_currentUserId, widget.otherUserId];
    ids.sort();
    return ids.join('_');
  }

  Future<void> _startCall(BuildContext context, bool isVideo) async {
    final channelName = _getChatDocumentId();
    try {
      final callId = await CallService.initiateCall(widget.otherUserId, channelName, isVideo);
      _navigateToCallScreen(channelName, isVideo, callId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting call: $e')),
      );
    }
  }

  void _navigateToCallScreen(String channelName, bool isVideo, String callId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          channelName: channelName,
          otherUserId: widget.otherUserId,
          otherUserName: widget.otherUserName,
          otherUserProfileImage: widget.otherUserProfileImage,
          isVideo: isVideo,
          callId: callId,
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_getChatDocumentId())
          .collection('messages')
          .add({
        'senderId': _currentUserId,
        'receiverId': widget.otherUserId,
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  Widget _buildMessage(Map<String, dynamic> messageData) {
    bool isMe = messageData['senderId'] == _currentUserId;
    DateTime? timestamp = (messageData['timestamp'] as Timestamp?)?.toDate();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messageData['message']),
            if (timestamp != null)
              Text(
                '${timestamp.hour}:${timestamp.minute}',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.otherUserProfileImage),
            ),
            SizedBox(width: 8),
            Text(widget.otherUserName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _startCall(context, false),
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _startCall(context, true),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var messageData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return _buildMessage(messageData);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
