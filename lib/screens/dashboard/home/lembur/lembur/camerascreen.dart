import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.cameraController});
  final CameraController cameraController;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.cameraController.value.isInitialized
        ? CameraPreview(widget.cameraController)
        : Container();
  }
}
