import 'package:get/get.dart';
import 'package:ur_style_player/models/audio.dart';

class HomeState {
  final RxList<AudioModel> _userSongs = <AudioModel>[].obs;
  List<AudioModel> get userSongs => _userSongs;
  set userSongs(value) => _userSongs.value = value;

  final Rx<int> _queueIndex = 0.obs;
  int get queueIndex => _queueIndex.value;
  set queueIndex(value) => _queueIndex.value = value;

  final RxList<dynamic> _playlist = <dynamic>[].obs;
  List<dynamic> get playlist => _playlist;
  set playlist(value) => _playlist.value = value;

  // current play song
  final Rx<AudioModel> _currentSong = AudioModel(
          title: "",
          author: "",
          duration: Duration.zero,
          audioId: "",
          isPlay: false,
          isUserSong: false,
          isDownloaded: false)
      .obs;
  AudioModel get currentSong => _currentSong.value;
  set currentSong(value) => _currentSong.value = value;
}
