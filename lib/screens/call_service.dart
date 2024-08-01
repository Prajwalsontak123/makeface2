import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Call states
  static const String CALL_STATE_RINGING = 'ringing';
  static const String CALL_STATE_ANSWERED = 'answered';
  static const String CALL_STATE_BUSY = 'busy';
  static const String CALL_STATE_MISSED = 'missed';
  static const String CALL_STATE_ENDED = 'ended';

  static Future<String> initiateCall(String otherUserId, String channelName, bool isVideo) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User is not logged in");
    }

    final userData = await _firestore.collection('loggedin_users').doc(currentUser.uid).get();
    final callerProfileImage = userData.data()?['profile_image'] ?? '';
    final callerName = userData.data()?['name'] ?? 'Unknown User';

    final callDoc = await _firestore.collection('calls').add({
      'caller': currentUser.uid,
      'callerName': callerName,
      'callerProfileImage': callerProfileImage,
      'callee': otherUserId,
      'channelName': channelName,
      'isVideo': isVideo,
      'status': CALL_STATE_RINGING,
      'timestamp': FieldValue.serverTimestamp(),
    });
    return callDoc.id;
  }

  static Stream<DocumentSnapshot> getCallStream(String callId) {
    return _firestore.collection('calls').doc(callId).snapshots();
  }

  static Future<void> answerCall(String callId) async {
    await updateCallStatus(callId, CALL_STATE_ANSWERED);
  }

  static Future<void> rejectCall(String callId) async {
    await updateCallStatus(callId, CALL_STATE_BUSY);
  }

  static Future<void> endCall(String callId) async {
    await updateCallStatus(callId, CALL_STATE_ENDED);
  }

  static Future<void> markCallAsMissed(String callId) async {
    await updateCallStatus(callId, CALL_STATE_MISSED);
  }

  static Stream<QuerySnapshot>? getIncomingCallStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    return _firestore
        .collection('calls')
        .where('callee', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: CALL_STATE_RINGING)
        .snapshots();
  }

  static Stream<QuerySnapshot>? getMissedCallStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    return _firestore
        .collection('calls')
        .where('callee', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: CALL_STATE_MISSED)
        .snapshots();
  }

  static Future<void> cleanupOldCalls() async {
    final thirtyMinutesAgo = DateTime.now().subtract(Duration(minutes: 30));
    final snapshot = await _firestore
        .collection('calls')
        .where('timestamp', isLessThan: thirtyMinutesAgo)
        .where('status', whereIn: [CALL_STATE_RINGING, CALL_STATE_ANSWERED])
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'status': CALL_STATE_MISSED});
    }
    await batch.commit();
  }

  static Future<Map<String, dynamic>> getCallerInfo(String callerId) async {
    final callerDoc = await _firestore.collection('loggedin_users').doc(callerId).get();
    return {
      'name': callerDoc.data()?['name'] ?? 'Unknown User',
      'profileImage': callerDoc.data()?['profile_image'] ?? '',
    };
  }

  static Future<void> updateCallStatus(String callId, String status) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': status,
    });
  }

  static Future<DocumentSnapshot> getCallDocument(String callId) {
    return _firestore.collection('calls').doc(callId).get();
  }

  static Stream<String> callStatusStream(String callId) {
    return _firestore.collection('calls').doc(callId).snapshots().map((snapshot) {
      return snapshot.data()?['status'] as String? ?? CALL_STATE_ENDED;
    });
  }

  static Future<String?> getAgoraToken(String channelName) async {
  try {
    final url = 'http://192.168.133.62:3000/getToken?channelName=$channelName';
    print("Attempting to fetch token from: $url");
    final response = await http.get(Uri.parse(url));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body)['token'];
    } else {
      print("Failed to fetch token: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching Agora token: $e");
    return null;
  }
}
}