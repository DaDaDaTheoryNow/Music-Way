import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ur_style_player/page/home/widgets/player_item.dart';
import 'index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.state.youtubeSongsId.length,
            itemBuilder: (context, index) {
              var youtubeSong = controller.state.youtubeSongsId[index];

              return Center(
                child: PlayerItem(
                  audioTitle: youtubeSong.title,
                  audioAuthor: youtubeSong.author,
                  audioDuration: youtubeSong.duration.toString(),
                  audioId: youtubeSong.audio_id,
                  index: index,
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          heroTag: "btnHome",
          onPressed: () => controller.handleGoChoose(),
          icon: const Icon(Icons.add),
          label: const Text("Add Song"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
