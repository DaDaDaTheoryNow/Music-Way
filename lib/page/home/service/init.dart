import 'dart:convert';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/page/application/index.dart';
import 'package:ur_style_player/page/home/service/stream_audio_source.dart';
import 'package:ur_style_player/page/home/service/update_current_song.dart';

import '../../../models/audio.dart';
import 'bytes_stream.dart';

class InitService {
  final AudioPlayer player;
  InitService(this.player);

  var state = Get.find<HomeController>().state;

  Future<void> cancelSong() async {
    await player.pause();
    await player.stop();

    updateCurrentSong(
        AudioModel(
            title: "",
            author: "",
            duration: Duration.zero,
            audioId: "",
            isPlay: false,
            isUserSong: false,
            isDownloaded: false),
        false);
  }

  void seekToNext() async {
    await player.seekToNext();

    AudioModel nextSong = state.userSongs[player.currentIndex!];
    nextSong.isPlay = true;
    state.currentSong = nextSong;
  }

  void duration() {
    // seek to next
    player.positionStream.listen((playingDuration) async {
      if (playingDuration > state.currentSong.duration) {
        if (state.playlist.length < 2) {
          await player.stop();
          await playlist(state.userSongs.first);
          player.play();
        } else {
          seekToNext();
        }
      }
    });
  }

  Future<void> playlist(AudioModel playModel) async {
    state.playlist.clear();

    var userSongs = state.userSongs;

    var initIndex = userSongs.indexOf(playModel);

    // if user added the song himself
    if (playModel.isUserSong) {
      for (var i = 0; i < userSongs.length; i++) {
        // adding in playlist
        // from internet
        if (userSongs[i].isDownloaded == false) {
          state.playlist.add(InternetStreamAudioSource(
              () async =>
                  await BytesStream().fetchBytesStream(userSongs[i].audioId),
              player,
              userSongs[i].audioId,
              userSongs[i].title));
        }

        // locale
        if (userSongs[i].isDownloaded == true) {} // soon
      }
    }

    // if user looking for song
    if (!playModel.isUserSong) {} // soon

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: false,
      shuffleOrder: DefaultShuffleOrder(),
      children: state.playlist,
    );

    await player.setAudioSource(
      playlist,
      initialIndex: initIndex,
      initialPosition: Duration.zero,
    );

    await player.setLoopMode(LoopMode.all);
    await player.setShuffleModeEnabled(false);
  }

  void deleteSong(AudioModel audioModel) async {
    await cancelSong();

    if (audioModel.isUserSong) {
      if (audioModel.isDownloaded) {} // soon

      if (!audioModel.isDownloaded) {
        state.userSongs.remove(audioModel);
      }

      // save songs
      List jsonList = [];
      for (AudioModel value in state.userSongs) {
        jsonList.add(value.toJson());
      }
      var jsonString = jsonEncode(jsonList);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userSongs', jsonString);
    }
  }
}
