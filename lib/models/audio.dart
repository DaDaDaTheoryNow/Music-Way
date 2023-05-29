// ignore_for_file: non_constant_identifier_names

class AudioModel {
  String title;
  String author;
  Duration duration;
  String audioId;
  String status; // loading, downloading, static, playing, error, next

  AudioModel(
      {required this.title,
      required this.author,
      required this.duration,
      required this.audioId,
      required this.status});

  // for save
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'duration': duration.inSeconds,
      'audioId': audioId,
      'status': status,
    };
  }

  // for loading
  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
        title: json['title'],
        author: json['author'],
        duration: Duration(seconds: json["duration"]),
        audioId: json['audioId'],
        status: json['status']);
  }
}
