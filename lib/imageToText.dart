import 'package:flutter/material.dart';
import 'package:test1/camera_view.dart';

class imageToText extends StatefulWidget {
  const imageToText({super.key});

  @override
  State<imageToText> createState() => _imageToTextState();
}

class _imageToTextState extends State<imageToText> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Video detection"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Điều hướng trở lại trang trước đó
          },
        ),
      ),
      body: const CameraView(),
    ));
  }
}
