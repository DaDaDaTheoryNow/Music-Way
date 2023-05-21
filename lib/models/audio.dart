// ignore_for_file: non_constant_identifier_names

class AudioModel {
  String title;
  String author;
  String duration;
  String audio_id;
  bool isPlay;

  AudioModel(
      {required this.title,
      required this.author,
      required this.duration,
      required this.audio_id,
      required this.isPlay});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'duration': duration,
      'audio_id': audio_id,
      'isPlay': isPlay,
    };
  }

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      title: json['title'],
      author: json['author'],
      duration: json['duration'],
      audio_id: json['audio_id'],
      isPlay: json['isPlay'],
    );
  }
}
