//create firebase function 
//record swipes funcs
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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

Future <void> storeSwipe({required String sessionID,required String userID,required String movieID, required bool liked}) async {
  try{
    final swipeID = FirebaseFirestore.instance.collection('sessions').doc('sessionID').collection('swipes').doc('userID');

    await swipeID.set({movieID : liked}, SetOptions(merge: true));
  }
  catch(e){
    print("Failed to store the swipe");
  }
}