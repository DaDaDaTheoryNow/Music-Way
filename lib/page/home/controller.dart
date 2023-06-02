import 'dart:convert';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/models/audio.dart';
import 'package:ur_style_player/page/home/service/init.dart';
import 'package:ur_style_player/page/home/service/update_current_song.dart';

import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();
  HomeController();

  final player = AudioPlayer(); // Create a player

  void handleGoChoose() async {
    InitService(player).cancelSong();

    Get.offNamedUntil("/add_song", (route) => true);
  }

  void playSongYoutube(AudioModel playModel) async {
    await InitService(player).playlist(playModel);

    playModel.isPlay = true;
    state.currentSong = playModel;

    InitService(player).duration();

    player.play();
  }

  void handlePauseResumeSong() {
    if (state.currentSong.isPlay) {
      player.pause();
    } else {
      player.play();
    }

    updateCurrentSong(state.currentSong, state.currentSong.isPlay);
  }

  void handlePlaySong(AudioModel audioModel) {
    playSongYoutube(audioModel);
  }

  void handleDeleteSong(AudioModel audioModel) {
    InitService(player).deleteSong(audioModel);
  }

  @override
  void onInit() async {
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
