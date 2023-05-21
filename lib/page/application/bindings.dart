import 'package:get/get.dart';

import 'index.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
