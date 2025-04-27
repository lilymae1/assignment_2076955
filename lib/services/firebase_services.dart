import 'package:flutter_local_notifications/flutter_local_notifications.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

Future <void> swipeRequest({required String fromuserID,required String toUserID, required String sessionID,}) async {
  final request = {
    'sessionsID': sessionID,
    'fromuserID': fromuserID,
    'toUserID': toUserID,
    'sentAt':FieldValue.serverTimestamp(),
    'status':'pending',
  };

  await FirebaseFirestore.instance.collection('swipeRequest').add(request);
}

Future<String> createSession(String userA, String userB, List<String> movieIds) async {
  final session = {
    'userA': userA,
    'userB': userB,
    'movies': movieIds,
    'swipes': {},
    'matches': [],
    'createdAt': FieldValue.serverTimestamp(),
  };

  final docRef = await FirebaseFirestore.instance.collection('sessions').add(session);
  return docRef.id;
}


Future<void> storeSwipe({
  required String sessionID,
  required String userID,
  required String movieID,
  required bool liked,
}) async {
  try {
    final swipeRef = FirebaseFirestore.instance
      .collection('sessions')
      .doc(sessionID)
      .collection('swipes')
      .doc(userID);

    await swipeRef.set({movieID: liked}, SetOptions(merge: true));
  } catch (e) {
    print("Failed to store the swipe: $e");
  }
}

Future<void> Match({
  required String sessionID,
  required String userID,
  required String movieID,
  required bool liked,
}) async{
  final otherUserSwipeRef = FirebaseFirestore.instance
    .collection('sessions')
      .doc(sessionID)
      .collection('swipes')
      .doc(userID);
  final otherUserSwipe = await otherUserSwipeRef.get();

  if(otherUserSwipe.exists){
    final data = otherUserSwipe.data();
    if(data != null && data[movieID] == true){
      final sessionRef = FirebaseFirestore.instance.collection('sessions').doc('sessionID');
      await sessionRef.update({'matches':FieldValue.arrayUnion([movieID])});
    }

  }


}

