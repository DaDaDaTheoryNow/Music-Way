import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/common/utils/parse_video_id.dart';
import 'package:ur_style_player/models/audio.dart';
import 'package:ur_style_player/page/add_song/index.dart';
import 'package:ur_style_player/page/home/index.dart';
import 'package:ur_style_player/service/audio/bytes_stream.dart';
import 'package:ur_style_player/service/audio/stream_audio_source.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AddSongService {
  Future<void> addSong(BuildContext context, AddSongState addSongState,
      HomeController homeController) async {
    // parse youtube id from video link
    var youtubeSongIdParse =
        ParseVideoId().extractVideoIdFromUrl(addSongState.youtubeUrl);

    // fetch all info about audio
    var yt = YoutubeExplode();
    var audioInfo = await yt.videos.get(youtubeSongIdParse);
    var audioTitle = audioInfo.title;
    var audioAuthor = audioInfo.author;
    var audioDuration = audioInfo.duration;

    List userSongs = homeController.state.userSongs;

    // add in songs list
    AudioModel audioModel = AudioModel(
        title: audioTitle,
        author: audioAuthor,
        duration: audioDuration ?? const Duration(seconds: 0),
        audioId: youtubeSongIdParse,
        isPlay: false,
        isUserSong: true,
        isDownloaded: false);
    userSongs.add(
      audioModel,
    );

    saveSongs(userSongs);

    // add to audio service queue
    AudioHandler audioHandler = homeController.audioHandler!;

    homeController.state.playlist.add(InternetStreamAudioSource(
        () async => await BytesStream().fetchBytesStream(audioModel.audioId),
        audioModel.audioId,
        audioModel.title,
        audioModel.author));

    await audioHandler.addQueueItem(MediaItem(
        id: audioModel.audioId,
        title: audioModel.title,
        artist: audioModel.author));
  }

  Future<void> saveSongs(List<dynamic> userSongs) async {
    List jsonList = [];
    for (AudioModel value in userSongs) {
      jsonList.add(value.toJson());
    }
    var jsonString = jsonEncode(jsonList);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userSongs', jsonString);
  }
}
