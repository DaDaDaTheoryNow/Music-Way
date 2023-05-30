import 'dart:async';

import 'package:just_audio/just_audio.dart';

class CurrentStreamAudioSource extends StreamAudioSource {
  final Future<Stream<List<int>>> Function() bytesStreamFactory;
  final AudioPlayer player;

  CurrentStreamAudioSource(this.bytesStreamFactory, this.player);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final transformer = StreamTransformer<List<int>, List<int>>.fromHandlers(
      handleData: (data, sink) {
        if (data.isNotEmpty) {
          sink.add(data);
        }
      },
    );

    final bytesStream = await bytesStreamFactory();

    final filtStream = bytesStream.transform(transformer);

    return StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: start,
      stream: filtStream,
      contentType: 'audio/raw',
    );
  }
}
