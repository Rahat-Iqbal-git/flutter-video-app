import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class LandingController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var appVideoPath = "".obs;
  var showPlayVideo = false.obs;

  @override
  onInit() {
    requestPermissions();
    super.onInit();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
    );
    videoPlayerController.initialize().then((value) {
      showPlayVideo.value = true;
      videoPlayerController.play();
    });
  }

  playVideo() async {
    showPlayVideo.value = true;
    videoPlayerController = VideoPlayerController.file(File(appVideoPath.value));
    await videoPlayerController.initialize();
    await videoPlayerController.play();
  }

  Future<void> requestPermissions() async {
    log("requestPermission");
    await Permission.storage.request();
     await  Permission.storage.status.then((value){
      log("storage status granted : ${value}");
    });
    // await Permission.storage.status;
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // } else {
    //   log("storage status granted : ${status.isGranted}");
    // }
  }
}
