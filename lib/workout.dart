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
  Timer? timer;
  Timer? ticker;
  void Function() onComplete;
  void Function(Timer timer, Duration remain) onTick;

  WorkOutTimer(this._duration, this.onComplete, this.onTick);

  void start() {
    timer = Timer(_duration, _onComplete);
    ticker = Timer.periodic(_tickInterval, _onTick);
  }

  void stop() {
    timer?.cancel();
    ticker?.cancel();
  }

  void _onComplete() {
    onComplete.call();
    ticker?.cancel();
  }

  void _onTick(Timer timer) {
    final Duration remain = Duration(seconds: _duration.inSeconds);
    onTick.call(timer, remain);
  }
}
