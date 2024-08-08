import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String iconPath;
  final String text;

  const CustomTab({super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 24, // Adjust size as needed
          height: 24,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11), // Adjust font size as needed
        ),
      ],
    );
  }
}
