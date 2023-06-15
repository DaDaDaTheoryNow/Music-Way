import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ur_style_player/common/utils/loading.dart';
import 'package:ur_style_player/main.dart';
import 'package:ur_style_player/page/application/index.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist =
      ConcatenatingAudioSource(useLazyPreparation: true, children: []);

  bool? playerPaused;
  HomeState? state;

  void init() async {
    // clear last session
    _playlist.clear();

    // load playlist
    _loadPlaylist();

    await _player.setAudioSource(_playlist,
        initialIndex: state!.queueIndex, initialPosition: Duration.zero);

    // play!
    play();
  }

  AudioHandler() {
    state = Get.find<HomeController>().state;

    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  void _loadPlaylist() {
    _playlist.clear();

    final mediaItems = state!.playlist
        .map((song) => MediaItem(
              id: song.id ?? "",
              title: song.title ?? "unknown",
              artist: song.author ?? "unknown",
            ))
        .toList();
    addQueueItems(mediaItems);
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setLoopMode(LoopMode.all);
      await _player.setShuffleModeEnabled(false);
      await _player.setAudioSource(_playlist, initialPosition: Duration.zero);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          if (_playlist.length > 1) MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          if (_playlist.length > 1) MediaControl.skipToNext,
        ],
        systemActions: const {},
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    // notify system
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  AudioSource _createAudioSource(MediaItem mediaItem) {
    bool found = false;
    for (var i = 0; i < state!.playlist.length; i++) {
      final audioSource = state!.playlist[i];

      if (audioSource.id == mediaItem.id) {
        found = true;
        return audioSource;
      }
    }

    switch (found) {
      case false:
        Get.snackbar("Error", "Сan't find song");
        break;
    }

    return AudioSource.uri(Uri.https("null"));
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    print("NOW: ${_playlist.children}");
    print("NOW: ${queue.value}");
    if (_playlist.length > 0 && _player.currentIndex != 0) {
      if (index == _player.currentIndex) {
        skipToNext();
      }

      // if playlist is null now
      if (_playlist.length == 1) {
        stop();
      }

      // manage Just Audio
      _playlist.removeAt(index);

      // notify system
      final newQueue = queue.value..removeAt(index);
      queue.add(newQueue);
    } else {
      print("index: $index");
      // manage Just Audio
      await _playlist.removeAt(index);

      // notify system
      final newQueue = queue.value..removeAt(index);
      queue.add(newQueue);

      skipToQueueItem(index);

      print(_playlist.children);
      print(queue.value);
      print(_player.currentIndex);
    }
  }

  @override
  Future<void> play() {
    playerPaused = false;
    return _player.play();
  }

  @override
  Future<void> pause() async {
    playerPaused = true;
    return _player.pause();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() async {
    if (playerPaused!) {
      return _player.seekToNext().then((value) async {
        play();
        await pause();
      });
    } else {
      return _player.seekToNext();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (playerPaused!) {
      return _player.seekToPrevious().then((value) async {
        play();
        await pause();
      });
    } else {
      return _player.seekToPrevious();
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      _player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
