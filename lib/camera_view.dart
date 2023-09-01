import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            // var topP = (controller.y)* (700);
            // var rightP = (controller.x) * (500);
            return controller.isCameraInitialized.value
                ? Column(children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CameraPreview(controller.cameraController),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              controller.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        controller.toggleCamera();
                      },
                      child: const Icon(Icons.switch_camera),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Detected Label: ${controller.label}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ])
                : const Center(child: Text("Loading Preview..."));
          }),
    );
  }
}
