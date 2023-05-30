import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/models/audio.dart';
import 'package:ur_style_player/page/home/service/bytes_stream.dart';
import 'package:ur_style_player/page/home/service/current_stream_audio.dart';

import 'index.dart';

class HomeController extends GetxController {
  final state = HomeState();
  HomeController();

  final player = AudioPlayer(); // Create a player

  void handleGoChoose() {
    Get.offNamedUntil("/add_song", (route) => true);
  }

  void playSongLocale() {}

  Future<void> playSongYoutube(AudioModel audioModel) async {
    var bytesStream = await BytesStream().fetchBytesStream(audioModel.audioId);
    var audioSource = CurrentStreamAudioSource(() async => bytesStream, player);

    await player.setAudioSource(audioSource);
    state.currentSong = audioModel;

    player.play();
  }

  void handlePlaySong(AudioModel audioModel) {
    playSongYoutube(audioModel);
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

  // update song state
  /*void statusYoutubeSongUpdate(int index, String status) {
    AudioModel audioModel = AudioModel(
        title: state.youtubeSongsId[index].title,
        author: state.youtubeSongsId[index].author,
        duration: state.youtubeSongsId[index].duration,
        audioId: state.youtubeSongsId[index].audioId,
        status: status);

    state.youtubeSongsId[index] = audioModel;
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
}*/
}
