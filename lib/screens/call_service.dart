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
    await _firestore.collection('calls').doc(callId).update({
      'status': CALL_STATE_ANSWERED,
    });
  }

  static Future<void> rejectCall(String callId) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': CALL_STATE_BUSY,
    });
  }

  static Future<void> endCall(String callId) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': CALL_STATE_ENDED,
    });
  }

  static Future<void> markCallAsMissed(String callId) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': CALL_STATE_MISSED,
    });
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

  // New method to update call status
  static Future<void> updateCallStatus(String callId, String status) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': status,
    });
  }

  // New method to get a specific call document
  static Future<DocumentSnapshot> getCallDocument(String callId) {
    return _firestore.collection('calls').doc(callId).get();
  }

  // New method to listen for changes in call status
  static Stream<String> callStatusStream(String callId) {
    return _firestore.collection('calls').doc(callId).snapshots().map((snapshot) {
      return snapshot.data()?['status'] as String? ?? CALL_STATE_ENDED;
    });
  }
}