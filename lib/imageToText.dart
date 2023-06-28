import 'package:flutter/material.dart';

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
        title: const Text("Image to text"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Điều hướng trở lại trang trước đó
          },
        ),
      ),
      body: const Center(
        child: Text(
            "Module which uses AI to detect hand sign to text is developing ..."),
      ),
    ));
  }
}
