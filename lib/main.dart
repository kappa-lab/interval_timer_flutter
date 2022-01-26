import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interval_timer/workout.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wakelock.enable();

    return MaterialApp(
      title: 'INTERVAL TIMER',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

class _MyHomePageState extends State<MyHomePage> {
  bool running = false;
  WorkOut data = WorkOut(const Duration(seconds: 5), 1);
  late WorkOutTimer timer;
  String debugMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Time'),
                  style: const TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Rep'),
                  style: const TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                Center(
                    child: SizedBox(
                        width: 300.0,
                        height: 60.0,
                        child: ElevatedButton(
                            key: null,
                            onPressed: onStartPressed,
                            child: Text(running ? "STOP" : "START")))),
                Text(
                  "[debug] $debugMsg",
                  style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF000000),
                      fontFamily: "RobotoMono"),
                ),
              ]),
          padding: const EdgeInsets.fromLTRB(50.0, 100.0, 50.0, 100.0),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  void onStartPressed() {
    setState(() {
      running = !running;
      if (running) {
        data = data;
        timer = WorkOutTimer(data.time, onComplete, onTick);
        timer.start();
        debugMsg = "start: ${data.time.inSeconds}";
      } else {
        timer.stop();
      }
    });
  }

  void onComplete() {
    setState(() {
      debugMsg = "comp : 0 ";
      running = false;
    });
  }

  void onTick(Timer timer, Duration remain) {
    setState(() {
      int r = (remain.inMilliseconds / 1000.0).round();
      debugMsg = "run  : ${Duration(seconds: r).inSeconds}";
    });
  }
}
