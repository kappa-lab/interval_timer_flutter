import 'dart:async';

class WorkOut {
  final Duration time;
  final int reps;

  WorkOut(this.time, this.reps);

  WorkOut increment() {
    return WorkOut(time, reps + 1);
  }
}

class WorkOutTimer {
  final Duration _duration;
  final Duration _tickInterval = const Duration(seconds: 1);
  Timer? _timer;
  Timer? _ticker;
  final Stopwatch _stopwatch = Stopwatch();

  void Function() onComplete;
  void Function(Timer timer, Duration remain) onTick;

  WorkOutTimer(this._duration, this.onComplete, this.onTick);

  void start() {
    _timer = Timer(_duration, _onComplete);
    _ticker = Timer.periodic(_tickInterval, _onTick);
    _stopwatch
      ..reset()
      ..start();
  }

  void stop() {
    _timer?.cancel();
    _ticker?.cancel();
    _stopwatch.stop();
  }

  void _onComplete() {
    onComplete.call();
    _ticker?.cancel();
    _stopwatch.stop();
  }

  void _onTick(Timer timer) {
    onTick.call(timer, _duration - _stopwatch.elapsed);
  }
}
