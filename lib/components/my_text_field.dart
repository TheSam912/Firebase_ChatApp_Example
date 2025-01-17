import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  FocusNode? focusNode;
  bool obscure;
  TextEditingController controller;


  MyTextField(
      {super.key,
      required this.hintText,
      required this.obscure,
      required this.controller,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary))),
        obscureText: obscure,
      ),
    );
  }
}
