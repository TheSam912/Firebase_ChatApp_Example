import 'dart:developer';

import 'package:chat_app_firebase/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  ///instance of firestore @ auth
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ///get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return fireStore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  ///send message
  Future<void> sendMessage(String receiverID, String message) async {
    final String? currentUserId = firebaseAuth.currentUser?.uid;
    final String? currentUserEmail = firebaseAuth.currentUser?.email;
    final Timestamp timestamp = Timestamp.now();

    ///create new message
    Message newMessage = Message(
        currentUserId!, currentUserEmail!, receiverID, message, timestamp);

    ///construct chatroom for two user id sort
    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatroomID = ids.join("_");

    /// add new messages to database
    await fireStore
        .collection("chatroom")
        .doc(chatroomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  /// get messages
  Stream<QuerySnapshot> getMessages(userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomID = ids.join('_');

    return fireStore
        .collection('chatroom')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
