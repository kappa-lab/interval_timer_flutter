import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeIndicator extends CustomPainter {
  final double _progress;

  double get progress => _progress;

  TimeIndicator(this._progress);

  @override
  void paint(Canvas canvas, Size size) {
    const shadowRect = Rect.fromLTWH(-103, -3, 206, 206);
    const rect = Rect.fromLTWH(-100, 0, 200, 200);
    const innerRect = Rect.fromLTWH(-100 + 5, 5, 200 - 10, 200 - 10);
    final shadow = Paint()
      ..color = const Color.fromARGB(0xFF, 0x18, 0x18, 0x18);
    final bg = Paint()..color = const Color.fromARGB(0xFF, 0x0F, 0x0F, 0x0F);
    final innerPt = Paint()
      ..color = const Color.fromARGB(0xFF, 0x1E, 0x1E, 0x1E);
    final fill = Paint()..color = const Color.fromARGB(0xFF, 0xE0, 0x30, 0x13);

    canvas
      ..drawArc(shadowRect, 0, 7, true, shadow)
      ..drawArc(rect, 0, 7, true, bg)
      ..drawArc(rect, 4.7, _progress * 6.28319, true, fill)
      ..drawArc(innerRect, 0, 7, false, innerPt);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

List<Widget> genRepIndicator(int reps, int current) {
  final List<Widget> list = [];
  for (var i = 0; i < reps - 1; i++) {
    list.add(SvgPicture.asset(
      'assets/run.svg',
      semanticsLabel: 'run',
      height: 20,
    ));
    list.add(
      SvgPicture.asset(
        'assets/rest.svg',
        semanticsLabel: 'rest',
        height: 20,
      ),
    );
  }

  list.add(
    SvgPicture.asset(
      'assets/last_run.svg',
      semanticsLabel: 'lastRun',
      height: 20,
    ),
  );

  return list;
}
