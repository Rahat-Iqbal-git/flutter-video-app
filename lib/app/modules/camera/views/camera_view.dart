import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../controllers/camera_controller.dart';

class AppCameraView extends GetView<AppCameraController> {
  const AppCameraView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var scale =
        size.aspectRatio * controller.cameraController.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Obx(() {
      if (controller.cameraInitialized.value == false) {
        return const Center(child: CircularProgressIndicator());
      }
      return SafeArea(
        child: Transform.scale(
          scale: scale,
          child: CameraPreview(
            controller.cameraController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (controller.isVideoRecording.value)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 5.0,
                      percent: controller.percentIndicatorValue.value,
                      center: InkWell(
                        onTap: () {
                          controller.stopAppVideoRecord();
                        },
                        child: const Icon(
                          Icons.stop_circle,
                          size: 50,
                        ),
                      ),
                      progressColor: Colors.green,
                      animateFromLastPercent: true,
                      animation: true,
                    ),
                  ),
                if (controller.isVideoRecording.isFalse)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black54,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
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
                      TextButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        label: const Text("Cancel"),
                        icon: const Icon(Icons.cancel),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
