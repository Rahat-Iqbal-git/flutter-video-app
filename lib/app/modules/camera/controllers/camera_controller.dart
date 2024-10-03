import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_video_camera/app/modules/landing/controllers/landing_controller.dart';
import 'package:get/get.dart';

class AppCameraController extends GetxController {
  var filePath = "".obs;
  var cameras = <CameraDescription>[].obs;
  var isFrontCamera = true.obs;
  late CameraController cameraController;
  var cameraInitialized = false.obs;
  var isVideoRecording = false.obs;
  var countdownSeconds = 0.obs;
  var percentIndicatorValue = 0.0.obs;
  late Timer timer;

  @override
  onInit() {
    super.onInit();
    loadCamera();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    Get.delete<AppCameraController>();
  }

  loadCamera() async {
    var camerasList = await availableCameras();
    cameras.addAll(camerasList);
    cameraController = CameraController(cameras[1], ResolutionPreset.max);

    cameraController.initialize().then((_) {
      cameraInitialized.value = true;
      log("Camera initialized");
    });
  }

  startAppVideoRecord() async {
    await cameraController.prepareForVideoRecording();
    await cameraController.startVideoRecording();
    isVideoRecording.value = true;

    int timerTicks = 0;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timerTicks == 9) {
          stopAppVideoRecord();
        }
        timerTicks++;
        percentIndicatorValue.value = timerTicks / 10;
      },
    );
  }

  stopAppVideoRecord() async {
    timer.cancel();
    var appVideoFile = await cameraController.stopVideoRecording();
    filePath.value = appVideoFile.path;
    isVideoRecording.value = false;
    Get.find<LandingController>().appVideoPath.value = appVideoFile.path;
     Get.find<LandingController>().playVideo();
    Get.back();
  }

  switchCamera() async {
    if (isFrontCamera.value) {
      await cameraController.setDescription(cameras[0]);
      isFrontCamera.value = false;
    } else {
      await cameraController.setDescription(cameras[1]);
      isFrontCamera.value = true;
    }
  }
}
