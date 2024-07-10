import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  String receiverEmail;

  ChatPage({super.key, required this.receiverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
    );
  }
}
