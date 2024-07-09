import 'package:chat_app_firebase/auth/login_or_register_page.dart';
import 'package:chat_app_firebase/firebase_options.dart';
import 'package:chat_app_firebase/pages/auth_gate.dart';
import 'package:chat_app_firebase/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: lightMode,
      home: const AuthGate(),
    );
  }
}