import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ur_style_player/common/utils/parse_video_id.dart';
import 'package:ur_style_player/models/audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
            try {
              Navigator.of(context).pop();
              LoadingUtil(context).startLoading();

              // parse youtube id from video link
              var youtubeSongIdParse =
                  ParseVideoId().extractVideoIdFromUrl(state.youtubeUrl);

              // fetch all info about audio
              var yt = YoutubeExplode();
              var audioInfo = await yt.videos.get(youtubeSongIdParse);
              var audioTitle = audioInfo.title;
              var audioAuthor = audioInfo.author;
              var audioDuration = audioInfo.duration;

              List youtubeSongsId =
                  Get.find<HomeController>().state.youtubeSongsId;

              // add in songs list
              AudioModel audioModel = AudioModel(
                title: audioTitle,
                author: audioAuthor,
                duration: audioDuration ?? const Duration(seconds: 0),
                audioId: youtubeSongIdParse,
                status: "static",
              );
              youtubeSongsId.add(
                audioModel,
              );

              // save songs
              List jsonList = [];
              for (AudioModel value in youtubeSongsId) {
                jsonList.add(value.toJson());
              }
              var jsonString = jsonEncode(jsonList);

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('save_songs', jsonString);

              Get.find<HomeController>().initPlayList();

              Get.snackbar("Success", "All done",
                  duration: const Duration(seconds: 1));
            } catch (e) {
              Get.snackbar("Error", "$e");
            }

            Get.close(2);
          }
        },
      ),
    );
  }
}
