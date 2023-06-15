import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common/pages.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? page) => GetMaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData.dark(),
        initialRoute: AppPages.application,
        getPages: AppPages.pages,
      ),
    );
  }
}
