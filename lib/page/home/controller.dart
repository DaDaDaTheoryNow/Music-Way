import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/common/utils/loading.dart';
import 'package:ur_style_player/models/audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();
  HomeController();

  final player = AudioPlayer(); // Create a player
  String idLocal = "";

  void handleGoChoose() {
    Get.offNamedUntil("/add_song", (route) => true);
    for (var i = 0; i < state.youtubeSongsId.length; i++) {
      addYoutubeSongToList(i, false);
      player.stop();
    }
  }

  void addYoutubeSongToList(int index, bool isPlay) {
    // add isPlay state
    AudioModel audioModel = AudioModel(
        title: state.youtubeSongsId[index].title,
        author: state.youtubeSongsId[index].author,
        duration: state.youtubeSongsId[index].duration,
        audio_id: state.youtubeSongsId[index].audio_id,
        isPlay: isPlay);

    state.youtubeSongsId[index] = audioModel;
  }

  void handlePlayYoutubeSongAsync(
      String id, int index, BuildContext context) async {
    bool isPlay = state.youtubeSongsId[index].isPlay;
    if (isPlay && idLocal == id) {
      isPlay = false;
      player.pause();
    } else if (isPlay == false && idLocal == id) {
      isPlay = true;
      player.play();
    } else {
      var yt = YoutubeExplode();

      LoadingUtil(context).startLoading();

      // delete last players
      for (var i = 0; i < state.youtubeSongsId.length; i++) {
        addYoutubeSongToList(i, false);
      }
      player.stop();

      // Get the video manifest.
      var manifest = await yt.videos.streamsClient.getManifest(id);
      var streams = manifest.audioOnly;

      // Get the audio track with the highest bitrate.
      var audio = streams.first;
      var audioStream = yt.videos.streamsClient.get(audio);

      // Convert the audio stream to bytes
      var bytes = await audioStream.reduce((a, b) => [...a, ...b]);
      var buffer = Uint8List.fromList(bytes);

      // save to file for audio player
      // Get the temporary directory path
      var tempDir = await getTemporaryDirectory();
      var tempPath = '${tempDir.path}/audio_temp.mp3';

      // Write the audio bytes to a temporary file
      var tempFile = File(tempPath);
      await tempFile.writeAsBytes(buffer);

      await player.setUrl(tempFile.path).then((value) {
        LoadingUtil(context).stopLoading();
      });

      idLocal = id;
      isPlay = true;

      player.play();
    }
    addYoutubeSongToList(index, isPlay);
  }

  @override
  void onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString("save_songs");

    if (jsonString != null) {
      List audioList = jsonDecode(jsonString);

      state.youtubeSongsId =
          audioList.map((map) => AudioModel.fromJson(map)).toList();
    }
    super.onInit();
  }
}
