import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/camera_controller.dart';

class AppCameraView extends GetView<AppCameraController> {
  const AppCameraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('CameraView'),
      //   centerTitle: true,
      // ),
      body: Obx(() {
        return SafeArea(
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (controller.cameraInitialized.value)
                CameraPreview(controller.cameraController),
              //
              if (controller.cameraInitialized.value == false)
                const CircularProgressIndicator(),
              //
              Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.startAppVideoRecord();
                      },
                      icon: const Icon(
                        Icons.play_circle,
                        size: 45,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.stopAppVideoRecord();
                      },
                      icon: const Icon(
                        Icons.pause_circle,
                        size: 45,
                        color: Colors.grey,
                      ),
                    ),
                      IconButton(
                      onPressed: () {
                        controller.switchCamera();
                      },
                      icon: const Icon(
                        Icons.rotate_left,
                        size: 45,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
