import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ur_style_player/models/audio.dart';

import '../../../common/utils/build_parse_duration.dart';
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
    return Padding(
      padding: EdgeInsets.only(top: 15.w, right: 10.w, left: 10.w),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(110, 158, 158, 158),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 75.h,
        child: Slidable(
          key: ValueKey(audioModel.audioId),
          endActionPane: ActionPane(
            extentRatio: 1,
            motion: const DrawerMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: const [
              SlidableAction(
                onPressed: null,
                backgroundColor: Color.fromARGB(216, 76, 248, 248),
                foregroundColor: Colors.white,
                icon: Icons.play_arrow,
                label: 'Play',
              ),
              SlidableAction(
                onPressed: null,
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                icon: Icons.download,
                label: 'Download',
              ),
              SlidableAction(
                onPressed: null,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              controller.handlePlaySong(audioModel);
            },
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
                        buildParseDuration(audioModel.duration),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.download))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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
