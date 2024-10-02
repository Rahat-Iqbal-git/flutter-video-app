import 'dart:io';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LandingController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var appVideoPath = "".obs;
  var showPlayVideo = false.obs;

  playVideo() async {
    showPlayVideo.value = true;
    videoPlayerController =
        VideoPlayerController.file(File(appVideoPath.value));
    await videoPlayerController.initialize();
    await videoPlayerController.play();
  }
}
