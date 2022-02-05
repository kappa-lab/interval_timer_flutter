import 'package:audioplayers/audioplayers.dart';

class SEPlayer {
  static const String _fileD0 = 'd0.wav';
  static const String _fileD1 = 'd1.wav';

  final AudioCache _cache;

  SEPlayer()
      : _cache = AudioCache(fixedPlayer: AudioPlayer())
          ..loadAll([_fileD0, _fileD1]);

  void playStart() => _cache.play(_fileD0);
  void playTick() => _cache.play(_fileD0);
  void playComplete() => _cache.play(_fileD1);
}
