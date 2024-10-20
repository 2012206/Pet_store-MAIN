import 'package:flutter/material.dart';
import 'package:pet_store_app/src/components/text/customText.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  final String videoUrl;
  final String title;
  const PlayVideo({super.key, required this.videoUrl, required this.title});

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  VideoPlayerController? videoPlayerController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController!.dispose();
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    videoPlayerController!.setLooping(true);
    videoPlayerController!.initialize().then((value) => setState(() {}));
    videoPlayerController!.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController!),
                ),
                SizedBox(
                  height: 2.h,
                ),
                CustomText(text: widget.title)
              ],
            ),
          ),
        ),
      )),
    );
  }
}
