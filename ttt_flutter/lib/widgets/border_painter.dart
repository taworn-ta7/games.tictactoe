import 'package:flutter/material.dart';
import '../game/game.dart' as game;
import '../constants.dart';

class BorderPainter extends CustomPainter {
  final game.Board board;
  final int index;

  BorderPainter({
    required this.board,
    required this.index,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double x0 = 0.0;
    double y0 = 0.0;
    double x1 = x0 + size.width;
    double y1 = y0 + size.height;
    double distanceX = Constants.distanceHuge;
    double distanceY = Constants.distanceHuge;

    int x = index % board.boardSize;
    int y = index ~/ board.boardSize;
    bool left = true;
    bool top = true;
    bool right = true;
    bool bottom = true;
    if (x <= 0) {
      left = false;
      x0 += distanceX;
    } else if (x >= board.boardSize - 1) {
      right = false;
      x1 -= distanceX;
    }
    if (y <= 0) {
      top = false;
      y0 += distanceY;
    } else if (y >= board.boardSize - 1) {
      bottom = false;
      y1 -= distanceY;
    }

    final paint = Paint()
      ..strokeWidth = Constants.distanceBig
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey;
    if (left) {
      canvas.drawLine(Offset(x0, y0), Offset(x0, y1), paint);
    }
    if (top) {
      canvas.drawLine(Offset(x0, y0), Offset(x1, y0), paint);
    }
    if (right) {
      canvas.drawLine(Offset(x1, y0), Offset(x1, y1), paint);
    }
    if (bottom) {
      canvas.drawLine(Offset(x0, y1), Offset(x1, y1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
