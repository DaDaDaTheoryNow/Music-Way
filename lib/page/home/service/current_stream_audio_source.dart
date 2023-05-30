import 'dart:async';

import 'package:just_audio/just_audio.dart';

class InternetStreamAudioSource extends StreamAudioSource {
  final Future<Stream<List<int>>> Function() bytesStreamFactory;
  final AudioPlayer player;

  InternetStreamAudioSource(this.bytesStreamFactory, this.player);

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
      contentType: 'audio/mp3',
    );
  }
}

class LocaleStreamAudioSource extends StreamAudioSource {
  final List<int> bytes;
  final AudioPlayer player;

  LocaleStreamAudioSource(this.bytes, this.player);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mp3',
    );
  }
}
