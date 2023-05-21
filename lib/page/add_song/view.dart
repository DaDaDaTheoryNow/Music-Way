import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ur_style_player/page/add_song/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeSong extends GetView<AddSongController> {
  const YoutubeSong({super.key});

  @override
  Widget build(BuildContext context) {
    var controllerWebView = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onUrlChange: (url) {
            String urlString = url.url!;
            if (urlString.startsWith('https://www.youtube.com/watch') ||
                urlString.startsWith('https://m.youtube.com/watch') &&
                    urlString != controller.state.youtubeUrl) {
              controller.handleYoutubeUrl(urlString, context);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.youtube.com/'));

    AppBar buildAppBar() {
      return AppBar(
        centerTitle: true,
        title: const Text("Find your desired song"),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: controllerWebView)),
        ],
      ),
    );
  }
}
