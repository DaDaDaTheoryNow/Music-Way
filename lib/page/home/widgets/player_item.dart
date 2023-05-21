import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../index.dart';

class PlayerItem extends GetView<HomeController> {
  final String audioTitle;
  final String audioAuthor;
  final String audioDuration;
  final String audioId;
  final int index;

  const PlayerItem({
    Key? key,
    required this.audioTitle,
    required this.audioAuthor,
    required this.audioDuration,
    required this.audioId,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      audioTitle,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    audioAuthor,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    audioDuration,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
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
                        controller.handlePlayYoutubeSongAsync(
                            audioId, index, context);
                      },
                      child: controller.state.youtubeSongsId[index].isPlay
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
