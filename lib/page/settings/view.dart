import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends GetView {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings"),
          ],
        ),
      ),
    );
  }
}
