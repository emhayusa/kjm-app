import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.file});

  final XFile file;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);
    return Image.file(picture);
  }
}
