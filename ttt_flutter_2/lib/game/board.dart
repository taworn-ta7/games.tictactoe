import 'package:logging/logging.dart';
import 'definitions.dart';
export 'definitions.dart';

class Board {
  static final log = Logger('Board');

  // ----------------------------------------------------------------------

  /// Board size: 3.
  static const int boardSize = 3;

  /// Total size, boardSize * boardSize.
  static const int totalSize = boardSize * boardSize;

  /// Current move data.
  final List<MarkerType?> moves = <MarkerType?>[
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  /// Current state: playing, have winner or draw.
  StateType state = StateType.playing;

  /// Current marker or winner.
  MarkerType marker = MarkerType.o;

  Board();

  // ----------------------------------------------------------------------

  void put(int index) {
    assert(state == StateType.playing);
    assert(index >= 0 && index < totalSize);
    assert(moves[index] == null);

    // move current
    moves[index] = marker;

    // update state
    if (_checkVictoryState()) {
      // current player is winner
      state = StateType.winner;
    } else if (_checkDrawState()) {
      // no more moves, both players draw
      state = StateType.draw;
    } else {
      // next player
      if (marker == MarkerType.o) {
        marker = MarkerType.x;
      } else {
        marker = MarkerType.o;
      }
    }
  }

  // ----------------------------------------------------------------------

  bool _checkYVictory(int y) {
    int x = 0;
    while (x < boardSize) {
      if (moves[y * boardSize + x] != marker) return false;
      x++;
    }
    log.info('$marker win with y=$y');
    return true;
  }

  bool _checkXVictory(int x) {
    int y = 0;
    while (y < boardSize) {
      if (moves[y * boardSize + x] != marker) return false;
      y++;
    }
    log.info('$marker win with x=$x');
    return true;
  }

  bool _checkDiagonalVictory0() {
    int i = 0;
    while (i < boardSize) {
      if (moves[i * boardSize + i] != marker) return false;
      i++;
    }
    log.info('$marker win with direct diagonal');
    return true;
  }

  bool _checkDiagonalVictory1() {
    int i = 0;
    while (i < boardSize) {
      if (moves[i * boardSize + (boardSize - i - 1)] != marker) return false;
      i++;
    }
    log.info('$marker win with reverse diagonal');
    return true;
  }

  bool _checkVictoryState() {
    // check horizontal
    for (int y = 0; y < boardSize; y++) {
      if (_checkYVictory(y)) return true;
    }

    // check vertical
    for (int x = 0; x < boardSize; x++) {
      if (_checkXVictory(x)) return true;
    }

    // check diagonal
    if (_checkDiagonalVictory0()) return true;
    if (_checkDiagonalVictory1()) return true;

    return false;
  }

  bool _checkDrawState() {
    return moves.every((item) => item != null);
  }
}
