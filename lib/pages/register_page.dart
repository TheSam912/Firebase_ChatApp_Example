import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  void Function() onTap;

  RegisterPage({super.key, required this.onTap});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void register(BuildContext context) async {
    AuthService authService = AuthService();
    if (passwordController.text == confirmPasswordController.text) {
      try {
        authService.signUpWithEmailPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }else{
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords not match !!!"),
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
            MyTextField(
              hintText: "Confirm Password",
              obscure: true,
              controller: confirmPasswordController,
            ),
            MyButton(
              buttonText: "Register",
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 12),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    " Login",
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
