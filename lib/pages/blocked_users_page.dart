import 'dart:developer';

import 'package:chat_app_firebase/services/auth/auth_service.dart';
import 'package:chat_app_firebase/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  showUnblockBox(context, userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Unblock User"),
          content: const Text("Are you sure you want to unblock this user?"),
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
                  ChatService().unBlockUser(userId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User unblocked!!!")));
                },
                child: Text(
                  "Unblock",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = authService.getCurrentUse()!.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Blocked Users"),
      ),
      body: StreamBuilder(
        stream: chatService.getBlockUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR !!!!!");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final blockedUsers = snapshot.data ?? [];
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text("NO BLOCKED USERS"),
            );
          }
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return TextButton.icon(
                onPressed: () {
                  showUnblockBox(context, userId);
                },
                label: Text(
                  user['email'],
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                icon: Icon(
                  Icons.block,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
