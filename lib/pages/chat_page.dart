import 'package:chat_app_firebase/components/my_bubble.dart';
import 'package:chat_app_firebase/components/my_text_field.dart';
import 'package:chat_app_firebase/services/auth/auth_service.dart';
import 'package:chat_app_firebase/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  String receiverEmail;
  String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          receiverID, messageController.text.toString());
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(receiverEmail),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [Expanded(child: buildMessageList()), buildUserInput()],
        ),
      ),
    );
  }

  buildMessageList() {
    String senderID = authService.getCurrentUse()!.uid;
    return StreamBuilder(
      stream: chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("ERROR !!!!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              bool isCurrentUser =
                  data['senderID'] == authService.getCurrentUse()!.uid;

              var _alignment =
                  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
              return Container(
                  alignment: _alignment,
                  child: MyBubble(
                      message: data['message'], isCurrentUser: isCurrentUser));
            },
          ).toList(),
        );
      },
    );
  }

  buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                  hintText: "Type a message",
                  obscure: false,
                  controller: messageController)),
          Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.green),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
