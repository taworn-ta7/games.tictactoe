import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';

class TitlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double x0 = 0.0;
    double y0 = 0.0;
    double x1 = x0 + size.width;
    double y1 = y0 + size.height;
    double xh = x0 + (size.width / 2);
    double yh = y0 + (size.height / 2);

    final paint = Paint()
      ..strokeWidth = Constants.distanceMedium
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey;
    canvas.drawLine(Offset(xh, y0), Offset(xh, y1), paint);
    canvas.drawLine(Offset(x0, yh), Offset(x1, yh), paint);

    final d = Constants.distanceBig;
    _paintO(
      canvas,
      Offset(x0 + d, y0 + d),
      Offset(xh - d, yh - d),
    );
    _paintX(
      canvas,
      Offset(xh + d, yh + d),
      Offset(x1 - d, y1 - d),
    );
  }

  void _paintO(Canvas canvas, Offset p0, Offset p1) {
    double xr = (p1.dx - p0.dx) / 2;
    double yr = (p1.dy - p0.dy) / 2;
    double r = min(xr, yr);
    double xc = p0.dx + xr;
    double yc = p0.dy + yr;

    final paint = Paint()
      ..strokeWidth = Constants.distanceMedium
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.blue;
    canvas.drawCircle(Offset(xc, yc), r, paint);
  }

  void _paintX(Canvas canvas, Offset p0, Offset p1) {
    final paint = Paint()
      ..strokeWidth = Constants.distanceMedium
      ..strokeCap = StrokeCap.round
      ..color = Colors.red;
    canvas.drawLine(p0, p1, paint);
    canvas.drawLine(Offset(p0.dx, p1.dy), Offset(p1.dx, p0.dy), paint);
  }

  // ----------------------------------------------------------------------

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
