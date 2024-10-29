import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_camera/app/modules/video_update/video_update_plugin_screen.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoUpdateScaffoldView extends StatefulWidget {
  const VideoUpdateScaffoldView({super.key});

  @override
  State<VideoUpdateScaffoldView> createState() => _VideoUpdateScaffoldViewState();
}

class _VideoUpdateScaffoldViewState extends State<VideoUpdateScaffoldView> {
  late VideoPlayerController videoPlayerController;
  late Future<void> initializeVideoPlayer;
  final flutterFFmpeg = FFmpegKit();
  String videoPath = "";
  bool showVideoPlayer = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  // addFilter() async {
  //   var output = videoPath.replaceAll(".mp4", "technonext.mp4");
  //   String filter = "eq=brightness=0:contrast=100:saturation=100";
  //   await FFmpegKit.execute('-i $videoPath -vf "$filter" $output').then((session) async {
  //     log(session.toString());
  //     var returnCode = await session.getReturnCode();
  //     log(returnCode.toString());
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       log("success : $output");
  //       setState(() {
  //         videoPlayerController = VideoPlayerController.file(File(output))
  //           ..initialize().then((_) {
  //             setState(() {});
  //           });
  //       });
  //     }else{
  //       var data = await session.getLogs();
  //       log("error : $data");
  //     }
  //   });
  // }

  Future<void> addFilter() async {
    final inputFile = File(videoPath);
    if (!await inputFile.exists()) {
      log("Error: The input video file does not exist at path: $videoPath");
      return;
    }
    // Generate the output file path
    var output = videoPath.replaceAll(".mp4", "554.mp4");
    String filter = "eq=brightness=100:contrast=1:saturation=1";

    // Execute FFmpeg command
    final session = await FFmpegKit.execute('-i $videoPath -vf "$filter" $output');

    // Check the return code of the session
    final returnCode = await session.getReturnCode();
    log(returnCode.toString());

    if (ReturnCode.isSuccess(returnCode)) {
      log(output);

      setState(() {
        videoPlayerController = VideoPlayerController.file(File(output))
          ..initialize().then((_) {
            videoPlayerController.play();
            videoPlayerController.setLooping(true);
            setState(() {});
          });
      });
    } else {
      var data = await session.getOutput();
      log("Error processing video: $data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video player view"),
      ),
      body: Column(
        children: [
          if (showVideoPlayer)
            FutureBuilder(
              future: initializeVideoPlayer,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          const SizedBox(height: 65),
          TextButton(
            onPressed: () async {
              pickVideo();
            },
            child: const Text("Pick Video"),
          ),
          TextButton(
            onPressed: () async {
              addFilter();
              // await Permission.storage.request();
            },
            child: const Text("Add Filter"),
          ),
          TextButton(
            onPressed: () async {
              Get.off(() {
                return VideoUpdatePluginScreen(file: File(videoPath));
              });
            },
            child: const Text("Go to video update plugin"),
          ),
        ],
      ),
    );
  }

  final picker = ImagePicker();
  pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoPath = pickedFile.path;
      videoPlayerController = VideoPlayerController.file(File(videoPath));
      initializeVideoPlayer = videoPlayerController.initialize().then((_) {
        videoPlayerController.play();
        videoPlayerController.setLooping(true);
        showVideoPlayer = true;
        setState(() {});
      });
    }
  }
}
