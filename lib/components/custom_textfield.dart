import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final Iterable<String>? autofillHints;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 187, 187, 187)),
          ),
          fillColor: Color.fromARGB(255, 236, 236, 236),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
