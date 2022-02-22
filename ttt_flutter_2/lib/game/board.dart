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

  /// Player first move: o or x.
  final MarkerType firstMove;

  /// Current marker, also use to indicate winner if state = winner.
  MarkerType _marker = MarkerType.o;
  MarkerType get marker => _marker;

  /// Current state: playing, winner or draw.
  StateType _state = StateType.playing;
  StateType get state => _state;

  /// Move data.
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

  /// History data.
  String _history = "";
  String get history => _history;

  /// Constructor.
  Board({
    required this.firstMove,
  }) {
    _marker = firstMove;
  }

  // ----------------------------------------------------------------------

  /// Put current marker into board.
  void put(int index) {
    assert(_state == StateType.playing);
    assert(index >= 0 && index < totalSize);
    assert(moves[index] == null);

    // move current
    moves[index] = _marker;
    _history += index.toString();

    // update state
    if (_checkVictoryState()) {
      // current player is winner
      _state = StateType.winner;
    } else if (_checkDrawState()) {
      // no more moves, both players draw
      _state = StateType.draw;
    } else {
      // next player
      if (_marker == MarkerType.o) {
        _marker = MarkerType.x;
      } else {
        _marker = MarkerType.o;
      }
    }
  }

  // ----------------------------------------------------------------------

  bool _checkYVictory(int y) {
    int x = 0;
    while (x < boardSize) {
      if (moves[y * boardSize + x] != _marker) return false;
      x++;
    }
    log.info('$_marker win with y=$y');
    return true;
  }

  bool _checkXVictory(int x) {
    int y = 0;
    while (y < boardSize) {
      if (moves[y * boardSize + x] != _marker) return false;
      y++;
    }
    log.info('$_marker win with x=$x');
    return true;
  }

  bool _checkDiagonalVictory0() {
    int i = 0;
    while (i < boardSize) {
      if (moves[i * boardSize + i] != _marker) return false;
      i++;
    }
    log.info('$_marker win with direct diagonal');
    return true;
  }

  bool _checkDiagonalVictory1() {
    int i = 0;
    while (i < boardSize) {
      if (moves[i * boardSize + (boardSize - i - 1)] != _marker) return false;
      i++;
    }
    log.info('$_marker win with reverse diagonal');
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
