import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_video_camera/app/modules/landing/controllers/landing_controller.dart';
import 'package:get/get.dart';


class AppCameraController extends GetxController {
  var filePath = "".obs;
  var cameras = <CameraDescription>[].obs;
  late CameraController cameraController;
  var cameraInitialized = false.obs;

  @override
  onInit(){
    super.onInit();
    loadCamera();
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
  }

  stopAppVideoRecord() async {
    var appVideoFile =  await cameraController.stopVideoRecording();
    filePath.value = appVideoFile.path;
    Get.find<LandingController>().appVideoPath.value = appVideoFile.path;
    Get.back();
  }
}
