import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class HomeState {
  final RxList _youtubeSongsId = [].obs;
  List get youtubeSongsId => _youtubeSongsId;
  set youtubeSongsId(value) => _youtubeSongsId.value = value;

  final RxList<AudioSource> _playlist = <AudioSource>[].obs;
  List<AudioSource> get playlist => _playlist;
  set playlist(value) => _playlist.value = value;
}
