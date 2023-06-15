import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class InternetStreamAudioSource extends StreamAudioSource {
  final Future<Stream<List<int>>> Function() bytesStreamFactory;

  final String id;
  final String title;
  final String author;

  InternetStreamAudioSource(
      this.bytesStreamFactory, this.id, this.title, this.author)
      : super(tag: MediaItem(id: id, title: title, artist: author));

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

// soon
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
