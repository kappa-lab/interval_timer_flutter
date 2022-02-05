import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interval_timer/workout.dart';
import 'package:wakelock/wakelock.dart';

import 'audio.dart';
import 'indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) Wakelock.enable();

    return MaterialApp(
      title: 'INTERVAL TIMER',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'INTERVAL TIMER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _ViewModel {
  String remainTime;
  int reps = 0;
  double progress = 0.0;
  double nextProgress = 0.0;
  _ViewModel(this.remainTime, this.reps);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _running = false;
  WorkOut _data = WorkOut(const Duration(seconds: 5), 2);
  late WorkOutTimer timer;
  late _ViewModel _viewModel = _ViewModel(
    _data.time.inSeconds.toString(),
    _data.reps,
  );

  late final SEPlayer se = SEPlayer();

//_cache.loadAll([SOUND_DATA_DOWN, SOUND_DATA_UP]);
// _cache.play(SOUND_DATA_UP);

  late final AnimationController percentageAnimationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..addListener(() {
          setState(() {
            _viewModel.progress = lerpDouble(
              _viewModel.progress,
              _viewModel.nextProgress,
              percentageAnimationController.value,
            )!;
          });
        });

  String debugMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0xFF, 0x1E, 0x1E, 0x1E),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(20.0)),
                  CustomPaint(painter: TimeIndicator(_viewModel.progress)),
                  const Padding(padding: EdgeInsets.all(36.0)),
                  Text(
                    _viewModel.remainTime,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 48.0,
                        color: Color(0xFFCCCCCC),
                        fontFamily: "RobotoMono"),
                  ),
                  const Padding(padding: EdgeInsets.all(50.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: genRepIndicator(_viewModel.reps, 0),
                  ),
                  const Padding(padding: EdgeInsets.all(25.0)),
                  ElevatedButton(
                    onPressed: _onStartPressed,
                    child: Text(_running ? "STOP" : "START"),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(15.0)),
            Container(
                color: const Color(0xFFE3E3E3),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "[debug] $debugMsg",
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF000000),
                          fontFamily: "RobotoMono",
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'time'),
                        onChanged: _onTimeChanged,
                        style: const TextStyle(
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                      ),
                    ])),
          ]),
    );
  }

  void _onTimeChanged(String? input) {
    setState(() {
      if (input == null) return;
      _data = WorkOut(Duration(seconds: int.parse(input)), 1);
      _viewModel.remainTime = "${_data.time.inSeconds}";
      debugMsg = "set: ${_data.time.inSeconds}";
    });
  }

  void _onStartPressed() {
    setState(() {
      _running = !_running;
      if (_running) {
        _viewModel = _ViewModel(_data.time.inSeconds.toString(), _data.reps)
          ..progress = 0.005;
        timer = WorkOutTimer(_data.time, _onComplete, _onTick);
        timer.start();
        se.playStart();

        debugMsg = "start: ${_data.time.inSeconds}";
      } else {
        timer.stop();
      }
    });
  }

  void _onComplete() {
    setState(() {
      _running = false;
      _viewModel.remainTime = "0";
      _viewModel.nextProgress = 1;
      percentageAnimationController.forward(from: 0.0);
      se.playComplete();

      debugMsg = "comp : 0 ";
    });
  }

  void _onTick(Timer timer, Duration remain) {
    setState(() {
      int r = (remain.inMilliseconds / 1000.0).round();
      int sec = Duration(seconds: r).inSeconds;
      int end = _data.time.inSeconds;

      _viewModel.nextProgress = (end - sec) / end;
      _viewModel.remainTime = "$sec";

      percentageAnimationController.forward(from: 0.0);

      if (sec <= 3) se.playTick();

      debugMsg = "run  : $sec";
    });
  }
}
