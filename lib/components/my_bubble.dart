import 'package:flutter/material.dart';

class MyBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  MyBubble({required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isCurrentUser ? Colors.green : Colors.grey.shade600),
      child: Text(message),
    );
  }
}
