import 'package:flutter/material.dart';
import 'package:flutter_video_camera/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing'),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(
            //   width: double.maxFinite,
            // ),
            if (controller.showPlayVideo.value)
              AspectRatio(
                aspectRatio: controller.videoPlayerController.value.aspectRatio,
                child: VideoPlayer(controller.videoPlayerController),
              ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.CAMERA);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Go to camera"),
            ),
            if (controller.appVideoPath.value != "")
              TextButton(
                onPressed: () {
                  controller.playVideo();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Play Video"),
              ),
          ],
        );
      }),
    );
  }
}
