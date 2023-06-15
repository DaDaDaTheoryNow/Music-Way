import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ur_style_player/service/audio/add_audio/add_audio.dart';

import '../../common/utils/loading.dart';
import 'index.dart';
import '../home/index.dart';

class AddSongController extends GetxController {
  final state = AddSongState();
  AddSongController();

  void handleGoYoutube() => Get.offNamedUntil("/youtube_song", (route) => true);

  void handleYoutubeUrl(url, context) {
    state.youtubeUrl = url;

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Confirmation',
        message: 'Are you sure about the song?',
        onConfirm: (bool confirmed) async {
          if (confirmed) {
            Navigator.of(context).pop();
            LoadingUtil(context).startLoading();

            HomeController homeController = Get.find<HomeController>();

            await AddSongService().addSong(context, state, homeController);

            Get.snackbar("Success", "All done",
                duration: const Duration(seconds: 1));

            Get.close(2);
          }
        },
      ),
    );
  }
}
