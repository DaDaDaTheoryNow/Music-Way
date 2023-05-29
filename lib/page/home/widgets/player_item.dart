import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ur_style_player/models/audio.dart';

import '../index.dart';

class PlayerItem extends GetView<HomeController> {
  final AudioModel audioModel;
  final int index;

  const PlayerItem({
    Key? key,
    required this.audioModel,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildDuration(duration) {
      duration = duration.toString().split('.').first.padLeft(8, "0");

      return Text(
        duration,
        style: TextStyle(
          fontSize: 15.sp,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 75.h,
      margin: EdgeInsets.only(top: 15.w, right: 10.w, left: 10.w),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 100.w,
            child: Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      audioModel.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    audioModel.author,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  // duration widget with format duration
                  buildDuration(audioModel.duration),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        controller.handleYoutubeSongManupulationAsync(
                            audioModel.audioId, index, "playing");
                      },
                      child: stateIcon(
                          controller.state.youtubeSongsId[index].status),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget stateIcon(String status) {
    switch (status) {
      case "static":
        return const Icon(Icons.play_arrow);
      case "playing":
        return const Icon(Icons.pause);
      case "loading":
        return const SpinKitRing(
          color: Colors.grey,
          size: 42,
          lineWidth: 5.2,
        );
      case "downloading":
        return const Icon(Icons.download);
      case "error":
        return const Icon(Icons.error);
    }
    return const Icon(Icons.play_arrow);
  }
}
