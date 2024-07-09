import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String buttonText;
  void Function() onTap;

  MyButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        alignment: Alignment.center,
        width: double.infinity,
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        child: Text(buttonText),
      ),
    );
  }
}
