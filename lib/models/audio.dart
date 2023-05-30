// ignore_for_file: non_constant_identifier_names

class AudioModel {
  String title;
  String author;
  Duration duration;
  String audioId;
  //String status; // loading, downloading, static, playing, error, next
  bool isPlay;
  bool isUserSong; // in future for users playlist sharing
  bool isDownloaded;

  AudioModel(
      {required this.title,
      required this.author,
      required this.duration,
      required this.audioId,
      required this.isPlay,
      required this.isUserSong,
      required this.isDownloaded});

  // for save
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'duration': duration.inSeconds,
      'audioId': audioId,
      'isPlay': isPlay,
      'isUserSong': isUserSong,
      'isDownloaded': isDownloaded,
    };
  }

  // for loading
  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      title: json['title'],
      author: json['author'],
      duration: Duration(seconds: json["duration"]),
      audioId: json['audioId'],
      isPlay: json['isPlay'],
      isUserSong: json['isUserSong'],
      isDownloaded: json['isDownloaded'],
    );
  }
}
