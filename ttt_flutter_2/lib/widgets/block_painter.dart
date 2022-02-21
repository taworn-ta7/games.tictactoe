import 'package:flutter/material.dart';
import '../game/game.dart' as game;

class BlockPainter extends CustomPainter {
  final game.MarkerType? marker;

  BlockPainter({
    required this.marker,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (marker == game.MarkerType.o) {
      // draw O
      var paint = Paint()
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = Colors.blue
        ..style = PaintingStyle.stroke;
      var halfX = size.width / 2;
      var halfY = size.height / 2;
      var center = Offset(halfX, halfY);
      var radius = halfX < halfY ? halfX : halfY;
      canvas.drawCircle(center, radius, paint);
    } else if (marker == game.MarkerType.x) {
      // draw X
      var paint = Paint()
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = Colors.red;
      var x0 = 0.0;
      var y0 = 0.0;
      var x1 = size.width;
      var y1 = size.height;
      canvas.drawLine(Offset(x0, y0), Offset(x1, y1), paint);
      canvas.drawLine(Offset(x1, y0), Offset(x0, y1), paint);
    } else {
      // draw mark
      var paint = Paint()
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = Colors.green;
      var x0 = 0.0;
      var y0 = 0.0;
      var x1 = size.width;
      var y1 = size.height;
      canvas.drawRect(Rect.fromPoints(Offset(x0, y0), Offset(x1, y1)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
