import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();

  late PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  void handlePageChanged(int index) {
    state.page = index;
  }

  void handleBottomBarPressed(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onInit() {
    bottomTabs = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: "Settings",
      ),
    ];
    pageController = PageController(initialPage: state.page);
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
