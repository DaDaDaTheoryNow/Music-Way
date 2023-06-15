import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ur_style_player/page/application/index.dart';

import '../../../common/utils/build_parse_duration.dart';

class PlayerBottomBar extends GetView<HomeController> {
  const PlayerBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(9),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 25, 26),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      width: MediaQuery.of(context).size.width,
      height: 77.h,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
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
                      child: Obx(() => Text(
                            controller.state.currentSong.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                    Obx(() => Text(
                          controller.state.currentSong.author,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        )),
                    // duration widget with format duration
                    Obx(() => buildParseDuration(
                        controller.state.currentSong.duration)),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => IconButton(
                        onPressed: () {
                          //controller.handlePauseResumeSong();
                        },
                        icon: (controller.state.currentSong.isPlay)
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                        iconSize: 28.h,
                        splashRadius: 25.h,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
