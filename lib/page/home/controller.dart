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
  var yt = YoutubeExplode(); // create youtube explode
  AudioModel? activeSong;

  void handleGoChoose() {
    Get.offNamedUntil("/add_song", (route) => true);
    for (var i = 0; i < state.youtubeSongsId.length; i++) {
      statusYoutubeSongUpdate(i, "static");
      player.pause();
    }
  }

  // update song state
  void statusYoutubeSongUpdate(int index, String status) {
    AudioModel audioModel = AudioModel(
        title: state.youtubeSongsId[index].title,
        author: state.youtubeSongsId[index].author,
        duration: state.youtubeSongsId[index].duration,
        audioId: state.youtubeSongsId[index].audioId,
        status: status);

    state.youtubeSongsId[index] = audioModel;
  }

  // play/pause/loading song
  void playYoutubeSong(String audioId, int buildIndex) async {
    if (activeSong != null) {
      if (player.playing && activeSong!.audioId == audioId) {
        player.pause();
        statusYoutubeSongUpdate(buildIndex, "static");
      } else if (player.audioSource != null && activeSong!.audioId == audioId) {
        player.play();
        statusYoutubeSongUpdate(buildIndex, "playing");
      }
    }
    if (activeSong == null || activeSong!.audioId != audioId) {
      for (var i = 0; i < state.youtubeSongsId.length; i++) {
        statusYoutubeSongUpdate(i, "static");
        player.stop();
      }

      statusYoutubeSongUpdate(buildIndex, "loading");

      try {
        activeSong = state.youtubeSongsId[buildIndex];

        final playlist = ConcatenatingAudioSource(
          shuffleOrder: DefaultShuffleOrder(),
          children: state.playlist,
        );

        await player.setAudioSource(
          playlist,
          initialIndex: buildIndex,
        );

        await player.setLoopMode(LoopMode.all);
        await player.setShuffleModeEnabled(false);

        player.positionStream.listen((Duration value) async {
          Duration duration = activeSong!.duration;
          if (value > duration) {
            playNextYoutubeSong(buildIndex);
          }
        });

        player.play();

        statusYoutubeSongUpdate(buildIndex, "playing");
      } catch (e) {
        statusYoutubeSongUpdate(buildIndex, "error");
      }

      activeSong!.audioId = audioId;
    }
  }

  Future<void> playNextYoutubeSong(int oldBuildIndex) async {
    await player.seekToNext();

    activeSong = state.youtubeSongsId[player.currentIndex!];

    for (var i = 0; i < state.youtubeSongsId.length; i++) {
      if (i == player.currentIndex!) {
        // update new song status
        statusYoutubeSongUpdate(player.currentIndex!, "playing");
      } else {
        // update past song status
        statusYoutubeSongUpdate(i, "static");
      }
    }
  }

  void handleYoutubeSongManupulationAsync(
      String audioId, int buildIndex, String statusSong) {
    switch (statusSong) {
      case "playing":
        playYoutubeSong(audioId, buildIndex);
        break;
      case "next":
        playNextYoutubeSong(buildIndex);
        break;
      default:
    }
  }

  Future<Stream<List<int>>> getStreamAudio(String audioId) async {
    // Get the video manifest.
    var manifest = await yt.videos.streamsClient.getManifest(audioId);

    // Get audio from video
    AudioOnlyStreamInfo streamInfo = manifest.audioOnly.first;
    var audioStream = yt.videos.streamsClient.get(streamInfo);

    return audioStream;
  }

  Future<void> initPlayList() async {
    // add saved songs in playlist
    for (var i = 0; i < state.youtubeSongsId.length; i++) {
      var audioId = state.youtubeSongsId[i].audioId;

      state.playlist.insert(
        i,
        MyStreamAudioSource(() => getStreamAudio(audioId), player),
      );
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

      await initPlayList();
    }

    super.onInit();
  }
}

class MyStreamAudioSource extends StreamAudioSource {
  final Future<Stream<List<int>>> Function() bytesStreamFactory;
  final AudioPlayer player;

  MyStreamAudioSource(this.bytesStreamFactory, this.player);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final transformer = StreamTransformer<List<int>, List<int>>.fromHandlers(
      handleData: (data, sink) {
        if (data.isNotEmpty) {
          sink.add(data);
        }
      },
    );

    final bytesStream = await bytesStreamFactory();

    final filtStream = bytesStream.transform(transformer);

    return StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: start,
      stream: filtStream,
      contentType: 'audio/raw',
    );
  }
}
