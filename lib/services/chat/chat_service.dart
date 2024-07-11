import 'package:chat_app_firebase/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  ///instance of firestore @ auth
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ///get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return fireStore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs
          .where(
              (doc) => doc.data()['email'] != firebaseAuth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

  /// get all users except block users
  Stream<List<Map<String, dynamic>>> getUsersExcludingBlocked() {
    final currentUser = firebaseAuth.currentUser;
    return fireStore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap(
      (snapShot) async {
        final blockedUserIds = snapShot.docs
            .map(
              (doc) => doc.id,
            )
            .toList();
        final userSnapShot = await fireStore.collection('users').get();
        return userSnapShot.docs
            .where(
              (doc) =>
                  doc.data()['email'] != currentUser.email &&
                  !blockedUserIds.contains(doc.id),
            )
            .map(
              (doc) => doc.data(),
            )
            .toList();
      },
    );
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

  /// report user
  Future<void> reportUser(messageId, userId) async {
    final currentUser = firebaseAuth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp()
    };
    await fireStore.collection('Reports').add(report);
  }

  /// block user
  Future<void> blockUser(userId) async {
    final currentUser = firebaseAuth.currentUser;
    await fireStore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  /// unBlock user
  Future<void> unBlockUser(blockedUserId) async {
    final currentUser = firebaseAuth.currentUser;
    await fireStore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  /// get block users stream
  Stream<List<Map<String, dynamic>>> getBlockUsersStream(userId) {
    return fireStore
        .collection('users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap(
      (snapShot) async {
        final blockedUserIds = snapShot.docs
            .map(
              (doc) => doc.id,
            )
            .toList();
        final userDocs = await Future.wait(blockedUserIds.map(
          (id) => fireStore.collection('users').doc(id).get(),
        ));
        return userDocs
            .map(
              (doc) => doc.data() as Map<String, dynamic>,
            )
            .toList();
      },
    );
  }
}
