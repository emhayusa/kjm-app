import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        //backgroundColor: Color.fromARGB(204, 41, 49, 211),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        // side: const BorderSide(color: Color.fromRGBO(41, 72, 211, 1)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
