import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String videoPath = "assets/bee.mp4";

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset(videoPath);
    initializeVideoPlayer = videoPlayerController.initialize().then((_) {
      videoPlayerController.play();
      // videoPlayerController.setLooping(true);
      setState(() {});
    });
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
  //  await  requestPermissions();
  await Permission.storage.request();

    // Check if the input video file exists
    final inputFile = File(videoPath);
    if (!await inputFile.exists()) {
      log("Error: The input video file does not exist at path: $videoPath");
      return; // Exit the function if the file does not exist
    }
    // Generate the output file path
    var output = videoPath.replaceAll(".mp4", "technonext.mp4");
    String filter = "eq=brightness=0:contrast=5:saturation=1";

    // Execute FFmpeg command
    final session = await FFmpegKit.execute('-i $videoPath -vf "$filter" $output');

    // Check the return code of the session
    final returnCode = await session.getReturnCode();
    log(returnCode.toString());

    if (ReturnCode.isSuccess(returnCode)) {
      log(output);

      // Initialize the video player with the new video file
      setState(() {
        videoPlayerController = VideoPlayerController.file(File(output))
          ..initialize().then((_) {
            setState(() {});
          });
      });
    } else {
      var data = await session.getOutput();
      log("Error processing video: $data");
    }
  }

  Future<void> requestPermissions() async {
    // var status = await Permission.storage.status;
    await Permission.storage.request();
  // await  Permission.storage.status.then((value){
  //     log("storage status grabnted : ${value}");
  //   });
    // log("storage status grabnted : ${status.isGranted}");
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }else{
    //   log("storage status grabnted : ${status.isGranted}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video player view"),
      ),
      body: Column(
        children: [
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
            onPressed: () async{
              // addFilter();
              await Permission.storage.request();
            },
            child: const Text("Add Filter"),
          ),
        ],
      ),
    );
  }
}
