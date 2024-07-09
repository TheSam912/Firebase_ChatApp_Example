import 'package:chat_app_firebase/auth/auth_service.dart';
import 'package:chat_app_firebase/components/my_button.dart';
import 'package:chat_app_firebase/components/my_text_field.dart';
import 'package:chat_app_firebase/theme/light_mode.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  void Function() onTap;

  LoginPage({super.key, required this.onTap});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.message, size: 50, color: Colors.black),
            const Text(
              "Vido",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 50,
            ),
            MyTextField(
                hintText: "Email", obscure: false, controller: emailController),
            MyTextField(
              hintText: "Password",
              obscure: true,
              controller: passwordController,
            ),
            MyButton(
              buttonText: "Login",
              onTap: () => login(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You don't have an account?",
                  style: TextStyle(fontSize: 12),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    " Register",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
