import 'package:get/get.dart';

class HomeState {
  final RxList _youtubeSongsId = [].obs;
  List get youtubeSongsId => _youtubeSongsId;
  set youtubeSongsId(value) => _youtubeSongsId.value = value;
}
