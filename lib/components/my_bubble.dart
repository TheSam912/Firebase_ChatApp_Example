import 'package:chat_app_firebase/services/chat/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  MyBubble(
      {required this.message,
      required this.isCurrentUser,
      required this.messageId,
      required this.userId});

  void showOptions(BuildContext context, messageId, userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Report"),
              onTap: () {
                Navigator.pop(context);
                _reportContent(context, messageId, userId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text("Block"),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showOptions(context, messageId, userId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCurrentUser ? Colors.green : Colors.grey.shade600),
        child: Text(message),
      ),
    );
  }
}

void _reportContent(BuildContext context, messageId, userId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Report message"),
        content: const Text("Are you sure you want to report this message?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
          TextButton(
              onPressed: () {
                ChatService().reportUser(messageId, userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message reported!!!")));
              },
              child: Text(
                "Report",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ))
        ],
      );
    },
  );
}

void _blockUser(BuildContext context, userId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Block User"),
        content: const Text("Are you sure you want to block this user?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
          TextButton(
              onPressed: () {
                ChatService().blockUser(userId);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User blocked!!!")));
              },
              child: Text(
                "Block",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ))
        ],
      );
    },
  );
}
