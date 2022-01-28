import 'package:flutter/material.dart';

class Indicator extends CustomPainter {
  final double _progress;

  double get progress => _progress;

  Indicator(this._progress);

  @override
  void paint(Canvas canvas, Size size) {
    const rect = Rect.fromLTWH(-100, 0, 200, 200);
    const innerRect = Rect.fromLTWH(-100 + 5, 5, 200 - 10, 200 - 10);
    final bg = Paint()..color = Colors.black38;
    final innerPt = Paint()..color = Colors.white;
    final fill = Paint()..color = Colors.black87;

    canvas
      ..drawArc(rect, 0, 7, true, bg)
      ..drawArc(rect, 4.7, _progress * 6.28319, true, fill)
      ..drawArc(innerRect, 0, 7, false, innerPt);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
