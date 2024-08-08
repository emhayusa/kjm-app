import 'package:flutter/material.dart';

class CustomButtonNoFill extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButtonNoFill(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: const BorderSide(color: Color.fromRGBO(252, 96, 17, 1)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(252, 96, 17, 1),
        ),
      ),
    );
  }
}
