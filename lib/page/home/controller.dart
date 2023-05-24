import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/models/audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();
  HomeController();

  final player = AudioPlayer(); // Create a player
  String cacheSong = "null";

  void handleGoChoose() {
    Get.offNamedUntil("/add_song", (route) => true);
    for (var i = 0; i < state.youtubeSongsId.length; i++) {
      statusYoutubeSongUpdate(i, "static");
      player.stop();
    }
  }

  // update song state
  void statusYoutubeSongUpdate(int index, String status) {
    AudioModel audioModel = AudioModel(
        title: state.youtubeSongsId[index].title,
        author: state.youtubeSongsId[index].author,
        duration: state.youtubeSongsId[index].duration,
        audio_id: state.youtubeSongsId[index].audio_id,
        status: status);

    state.youtubeSongsId[index] = audioModel;
  }

  // play/pause song
  void playYoutubeSong(String audioId, int buildIndex) async {
    var yt = YoutubeExplode();

    if (player.playing && cacheSong == audioId) {
      player.pause();
      statusYoutubeSongUpdate(buildIndex, "static");
    } else if (player.audioSource != null && cacheSong == audioId) {
      player.play();
      statusYoutubeSongUpdate(buildIndex, "playing");
    }

    if (cacheSong != audioId) {
      for (var i = 0; i < state.youtubeSongsId.length; i++) {
        statusYoutubeSongUpdate(i, "static");
        player.stop();
      }

      statusYoutubeSongUpdate(buildIndex, "loading");

      try {
        // Get the video manifest.
        var manifest = await yt.videos.streamsClient.getManifest(audioId);

        AudioOnlyStreamInfo streamInfo = manifest.audioOnly.first;
        var audioStream = yt.videos.streamsClient.get(streamInfo);
        var audioSource =
            MyStreamAuidoSource(audioStream); // var for play from stream

        await player.setAudioSource(audioSource);
        player.play();
        statusYoutubeSongUpdate(buildIndex, "playing");
      } catch (e) {
        statusYoutubeSongUpdate(buildIndex, "error");
      }

      cacheSong = audioId;
    }
  }

  void handleYoutubeSongManupulationAsync(
      String audioId, int buildIndex, String statusSong) {
    switch (statusSong) {
      case "playing":
        playYoutubeSong(audioId, buildIndex);
        break;
      default:
    }
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

class MyStreamAuidoSource extends StreamAudioSource {
  final Stream<List<int>> bytesStream;

  MyStreamAuidoSource(this.bytesStream) : super(tag: "MyStreamAuidoSource");

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final filteredStream = bytesStream
        .map((data) => data.sublist(start ?? 0, end))
        .where((data) => data.isNotEmpty);

    return StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: start ?? 0,
      stream: filteredStream,
      contentType: 'audio/mp3',
    );
  }
}
