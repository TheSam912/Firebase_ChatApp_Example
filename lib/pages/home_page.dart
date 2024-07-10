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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("HOME"),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ChatPage(
              receiverEmail: userdata['email'],
            );
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 2),
              color: Colors.white),
          child: TextButton.icon(
            onPressed: () {},
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
        ),
      ),
    );
  }
}
