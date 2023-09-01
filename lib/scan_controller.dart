import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:developer';

enum ActiveCamera { front, back }

class ScanController extends GetxController {
  @override
  void onInit() {
    print('Start hehe');

    super.onInit();
    initCamera();
    initTFLite();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late ReceivePort receivePort;
  late StreamSubscription<dynamic> receivePortSubscription;

  ActiveCamera activeCamera = ActiveCamera.back;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  var x, y, w, h = 0.0;
  var label = "";

  initCamera() async {
    print('1 hehe');
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      if (activeCamera == ActiveCamera.front) {
        cameraController =
            CameraController(cameras[1], ResolutionPreset.medium);
      } else {
        cameraController =
            CameraController(cameras[0], ResolutionPreset.medium);
      }
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetect(image);
          }
          update();
        });

        // receivePort = ReceivePort();
        // receivePortSubscription = receivePort.listen((dynamic data) {
        //   if (data is CameraImage) {
        //     cameraCount++;
        //     if (cameraCount % 10 == 0) {
        //       cameraCount = 0;
        //       // Run object detection in a separate isolate
        //       Future.microtask(() => objectDetect(data));
        //     }
        //     update();
        //   }
        // });
        // cameraController.startImageStream((CameraImage image) {
        //   receivePort.sendPort.send(image);
        // });

        // cameraController.startImageStream((image) {
        //   cameraCount++;
        //   if (cameraCount % 10 == 0) {
        //     cameraCount = 0;
        //     objectDetect(image);
        //   }
        //   update();
        // });
      });
      isCameraInitialized(true);
      update();
    } else {
      // ignore: avoid_print
      print("Permission denied");
    }
  }

  void toggleCamera() {
    if (activeCamera == ActiveCamera.front) {
      activeCamera = ActiveCamera.back;
    } else {
      activeCamera = ActiveCamera.front;
    }
    // Reinitialize the camera
    initCamera();
  }

  // Future initTFLite() async {
  //   Tflite.close();
  //   print('2 hehe');
  //   await Tflite.loadModel(
  //       model: "assets/model.tflite",
  //       labels: "assets/label.txt",
  //       isAsset: true,
  //       numThreads: 1,
  //       useGpuDelegate: false);

  //   // useGpuDelegate: false);
  // }

  initTFLite() async {
    Tflite.close();
    print("2 hehe");
    try {
      String res;
      res = (await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        isAsset: true,
        useGpuDelegate: true
      ))!;
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  objectDetect(CameraImage image) async {
    print('3hehe');
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        rotation: 90,
        threshold: 0.4,
        asynch: false);

    if (detector != null && detector.isNotEmpty) {
      log("Result is $detector");
      label = detector.first["label"].toString();
      update();
    }
  }

  @override
  void dispose() {
    print('End hehe');
    super.dispose();
    cameraController.dispose();
    // receivePortSubscription.cancel();
  }
}
