import 'package:get/get.dart';

import 'index.dart';

class AddSongBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSongController>(() => AddSongController());
  }
}
