import 'package:audioplayers/audioplayers.dart';

class SEPlayer {
  final AudioCache _cache;

  SEPlayer()
      : _cache = AudioCache(fixedPlayer: AudioPlayer())
          ..loadAll([
            _FilePath.start,
            _FilePath.tick,
            _FilePath.comp,
          ]);

  void playStart() => _cache.play(_FilePath.start);
  void playTick() => _cache.play(_FilePath.tick);
  void playComplete() => _cache.play(_FilePath.comp);
}

class _FilePath {
  static const String start = 'start.wav';
  static const String tick = 'tick.wav';
  static const String comp = 'comp.wav';
}
