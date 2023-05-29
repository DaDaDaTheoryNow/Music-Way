import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildPageView() {
      return PageView(
        controller: controller.pageController,
        onPageChanged: controller.handlePageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(), // CounterPage
          SettingsPage(), // SettingsPage
        ],
      );
    }

    Widget buildBottomBar() {
      return Obx(
        () => BottomNavigationBar(
            currentIndex: controller.state.page,
            onTap: controller.handleBottomBarPressed,
            items: controller.bottomTabs),
      );
    }

    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: buildBottomBar(),
    );
  }
}
