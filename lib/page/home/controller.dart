import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/models/audio.dart';
import 'package:ur_style_player/service/audio/audio_handler/audio_handler.dart';

import '../../service/audio/init.dart';
import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();
  HomeController();

  AudioHandler? audioHandler; // Create a song handler

  void handleGoChoose() async {
    Get.offNamedUntil("/add_song", (route) => true);
  }

  void handleDeleteSong(AudioModel deleteModel) async {
    await InitService().deleteSong(deleteModel, audioHandler!);
  }

  void handlePlaySong(AudioModel playModel) async {
    await InitService()
        .playlist(playModel); // set state.playlist & state.queueIndex

    playModel.isPlay = true;
    state.currentSong = playModel;

    audioHandler!.init();
  }

  @override
  void onInit() async {
    // init audioHandler
    audioHandler = await initAudioService();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString("userSongs");

    if (jsonString != null) {
      List audioList = jsonDecode(jsonString);

      state.userSongs =
          audioList.map((map) => AudioModel.fromJson(map)).toList();
    }

    super.onInit();
  }
}
