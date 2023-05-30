import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ur_style_player/models/audio.dart';

class HomeState {
  final RxList<AudioModel> _userSongs = <AudioModel>[].obs;
  List<AudioModel> get userSongs => _userSongs;
  set userSongs(value) => _userSongs.value = value;

  final RxList<AudioSource> _playlist = <AudioSource>[].obs;
  List<AudioSource> get playlist => _playlist;
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
