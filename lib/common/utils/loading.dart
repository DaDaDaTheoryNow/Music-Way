import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingUtil {
  late BuildContext context;

  LoadingUtil(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: SpinKitRing(
                color: Colors.grey,
                size: 50,
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }
}
