import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interval_timer/workout.dart';
import 'package:wakelock/wakelock.dart';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool running = false;
  WorkOut data = WorkOut(const Duration(seconds: 5), 1);
  late WorkOutTimer timer;
  String remainTime = "5";
  double progress = 0;

  double newProgress = 0.0;
  late final AnimationController percentageAnimationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..addListener(() {
          setState(() {
            progress = lerpDouble(
                progress, newProgress, percentageAnimationController.value)!;
          });
        });

  String debugMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(20.0)),
                CustomPaint(painter: Indicator(progress)),
                const Padding(padding: EdgeInsets.all(36.0)),
                Text(
                  remainTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 48.0,
                      color: Color(0xFF000000),
                      fontFamily: "RobotoMono"),
                ),
                const Padding(padding: EdgeInsets.all(60.0)),
                ElevatedButton(
                  key: null,
                  onPressed: _onStartPressed,
                  child: Text(running ? "STOP" : "START"),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          Text(
            "[debug] $debugMsg",
            style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFF000000),
                fontFamily: "RobotoMono"),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'time'),
            onChanged: _onTimeChanged,
            style: const TextStyle(
                color: Color(0xFF000000),
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
          ),
        ],
      ),
    );
  }

  void _onTimeChanged(String? input) {
    setState(() {
      if (input == null) return;
      data = WorkOut(Duration(seconds: int.parse(input)), 1);
      remainTime = "${data.time.inSeconds}";
      debugMsg = "set: ${data.time.inSeconds}";
    });
  }

  void _onStartPressed() {
    setState(() {
      running = !running;
      if (running) {
        timer = WorkOutTimer(data.time, _onComplete, _onTick);
        timer.start();
        remainTime = "${data.time.inSeconds}";
        progress = 0.005;

        int end = data.time.inSeconds;
        newProgress = 0.005;

        debugMsg = "start: ${data.time.inSeconds}";
      } else {
        timer.stop();
      }
    });
  }

  void _onComplete() {
    setState(() {
      remainTime = "0";
      running = false;
      newProgress = 1;
      percentageAnimationController.forward(from: 0.0);
      debugMsg = "comp : 0 ";
    });
  }

  void _onTick(Timer timer, Duration remain) {
    setState(() {
      int r = (remain.inMilliseconds / 1000.0).round();
      int sec = Duration(seconds: r).inSeconds;
      int end = data.time.inSeconds;

      newProgress = (end - sec) / end;
      remainTime = "$sec";

      percentageAnimationController.forward(from: 0.0);

      debugMsg = "run  : $sec";
    });
  }
}
