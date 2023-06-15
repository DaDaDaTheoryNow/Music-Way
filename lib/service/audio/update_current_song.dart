import 'package:get/get.dart';

import '../../models/audio.dart';
import '../../page/home/controller.dart';



void updateCurrentSong(AudioModel audioModel, bool isPlay) {
  audioModel.isPlay = !isPlay;

  Get.find<HomeController>().state.currentSong = AudioModel(
      title: audioModel.title,
      author: audioModel.author,
      duration: audioModel.duration,
      audioId: audioModel.audioId,
      isPlay: audioModel.isPlay,
      isUserSong: audioModel.isUserSong,
      isDownloaded: audioModel.isDownloaded);
}
