import 'package:get/get.dart';

class AddSongState {
  final RxString _youtubeUrl = "unknown".obs;
  String get youtubeUrl => _youtubeUrl.value;
  set youtubeUrl(value) => _youtubeUrl.value = value;
}
