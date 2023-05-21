import 'package:get/get.dart';

import '../page/application/index.dart';
import '../page/add_song/index.dart';

class AppPages {
  static const application = "/application";
  static const home = "/home";
  static const settings = "/settings";

  static const addSong = "/add_song";

  static final List<GetPage> pages = [
    // application
    GetPage(
        name: application,
        page: () => const ApplicationPage(),
        binding: ApplicationBinding()),

    // counter
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    // settings
    GetPage(
        name: settings,
        page: () => const SettingsPage(),
        binding: SettingsBinding()),

    // add song
    GetPage(
        name: addSong,
        page: () => const YoutubeSong(),
        binding: AddSongBinding()),
  ];
}
