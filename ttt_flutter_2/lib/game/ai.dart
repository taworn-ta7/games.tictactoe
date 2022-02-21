import 'dart:math';
import 'board.dart';

Future<int> computerRandom(Board board) async {
  // random how to move
  final random = Random();
  var value = random.nextInt(100);
  var index = 0;
  while (true) {
    if (value > 0) {
      index++;
      if (index >= Board.totalSize) {
        index = 0;
      }
      value--;
    } else {
      if (board.moves[index] != null) {
        index++;
        if (index >= Board.totalSize) {
          index = 0;
        }
      } else {
        break;
      }
    }
  }

  return index;
}
