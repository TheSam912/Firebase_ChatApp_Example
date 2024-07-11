import 'dart:math';

import 'package:chat_app_firebase/services/chat/chat_service.dart';

import '../services/auth/auth_service.dart';
import 'package:chat_app_firebase/components/my_drawer.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  ChatService chatService = ChatService();

  showUserEmail() {
    String? detail = authService.getCurrentUse()?.email;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(detail.toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("HOME"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => showUserEmail(), icon: Icon(Icons.info_outline))
        ],
      ),
      drawer: const MyDrawer(),
      body: buildUserList(),
    );
  }

  buildUserList() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("ERROR !!!!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>(
                (userData) => buildUserItemList(userData, context),
              )
              .toList(),
        );
      },
    );
  }

  buildUserItemList(Map<String, dynamic> userdata, BuildContext context) {
    if (userdata["email"] != authService.getCurrentUse()?.email) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.white),
        child: TextButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ChatPage(
                  receiverEmail: userdata['email'],
                  receiverID: userdata['uid'],
                );
              },
            ));
          },
          label: Text(
            userdata['email'],
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700),
          ),
          icon: const Icon(
            Icons.person,
            color: Colors.black,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
