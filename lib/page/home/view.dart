import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ur_style_player/page/home/widgets/player_item.dart';
import 'index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(7),
                child: FloatingActionButton.extended(
                  heroTag: "btnHome",
                  onPressed: () => controller.handleGoChoose(),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Song"),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.state.userSongs.length,
            itemBuilder: (context, index) {
              var youtubeSongModel = controller.state.userSongs[index];

              return Center(
                child: PlayerItem(
                  audioModel: youtubeSongModel,
                  index: index,
                ),
              );
            },
          ),
        ),
      ),
      /*floatingActionButton: Obx(() =>
          (controller.state.currentSong.audioId.isNotEmpty)
              ? const PlayerBottomBar()
              : Container()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
    );
  }
}
