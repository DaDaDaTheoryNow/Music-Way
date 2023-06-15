import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ur_style_player/page/application/index.dart';
import 'package:ur_style_player/service/audio/stream_audio_source.dart';

import '../../models/audio.dart';
import 'bytes_stream.dart';

class InitService {
  var state = Get.find<HomeController>().state;

  Future<void> playlist(AudioModel playedModel) async {
    var userSongs = state.userSongs;

    state.playlist.clear();

    if (playedModel.isUserSong) {
      for (var i = 0; i < userSongs.length; i++) {
        // from internet
        if (userSongs[i].isDownloaded == false) {
          state.playlist.add(
            InternetStreamAudioSource(
                () async =>
                    await BytesStream().fetchBytesStream(userSongs[i].audioId),
                userSongs[i].audioId,
                userSongs[i].title,
                userSongs[i].author),
          );
        }

        // locale
        //if (userSongs[i].isDownloaded == true) {} // soon
      }

      state.queueIndex = userSongs.indexOf(playedModel);
    }
  }

  Future<void> deleteSong(
      AudioModel deletedModel, AudioHandler audioHandler) async {
    if (deletedModel.isUserSong) {
      int deleteIndex = state.userSongs.indexOf(deletedModel);

      await audioHandler.removeQueueItemAt(deleteIndex);

      // delete from current playlist
      if (state.playlist.isNotEmpty) {
        await state.playlist.removeAt(deleteIndex);
      }

      if (!deletedModel.isDownloaded) {
        state.userSongs.removeAt(deleteIndex);
      } //if (audioModel.isDownloaded) {} // soon

      saveSongs();
    }
  }

  Future<void> saveSongs() async {
    List jsonList = [];
    for (AudioModel value in state.userSongs) {
      jsonList.add(value.toJson());
    }
    var jsonString = jsonEncode(jsonList);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userSongs', jsonString);
  }
}
