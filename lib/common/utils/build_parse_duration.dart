import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildParseDuration(duration) {
  duration = duration.toString().split('.').first.padLeft(8, "0");

  return Text(
    duration,
    style: TextStyle(
      fontSize: 15.sp,
      fontStyle: FontStyle.italic,
    ),
  );
}
