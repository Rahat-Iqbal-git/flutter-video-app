import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoUpdate extends StatefulWidget {
  const VideoUpdate({super.key});

  @override
  State<VideoUpdate> createState() => _VideoUpdateState();
}

class _VideoUpdateState extends State<VideoUpdate> {
  late VideoPlayerController videoPlayerController;
  late Future<void> initializeVideoPlayer;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset("assets/bee.mp4");
    initializeVideoPlayer = videoPlayerController.initialize().then((_) {
      videoPlayerController.play();
      videoPlayerController.setLooping(true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio ,
              child: VideoPlayer(videoPlayerController),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
