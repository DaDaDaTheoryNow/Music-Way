import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class BytesStream {
  // fetch bytes stream from audio
  Future<Stream<List<int>>> fetchBytesStream(String audioId) async {
    var yt = YoutubeExplode(); // create youtube explode

    // Get the video manifest.
    var manifest = await yt.videos.streamsClient.getManifest(audioId);

    // Fetch audio from video
    AudioOnlyStreamInfo streamInfo = manifest.audioOnly.first;
    var audioStream = yt.videos.streamsClient.get(streamInfo);

    return audioStream;
  }
}
