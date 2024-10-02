import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/camera_controller.dart';

class AppCameraView extends GetView<AppCameraController> {
  const AppCameraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CameraView'),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.maxFinite,
            ),
            if (controller.cameraInitialized.value)
              SizedBox(
                  height: Get.height - 200,
                  child: CameraPreview(controller.cameraController)),
            //
            if (controller.cameraInitialized.value == false)
              const CircularProgressIndicator(),
            //
            Row(
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
              ],
            ),
          ],
        );
      }),
    );
  }
}
