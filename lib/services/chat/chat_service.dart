import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  ///instance of
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  ///get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return fireStore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }
}
