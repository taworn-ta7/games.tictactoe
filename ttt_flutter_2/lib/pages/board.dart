import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../i18n/strings.g.dart';
import '../game/game.dart' as game;
import '../widgets/message_box.dart';
import '../widgets/block_painter.dart';
import '../widgets/border_painter.dart';
import '../loggings.dart';

enum OpponentType {
  player,
  computer,
  network,
}

class BoardPage extends StatefulWidget {
  final game.Board board;
  final OpponentType opponentType;

  const BoardPage({
    Key? key,
    required this.board,
    required this.opponentType,
  }) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<BoardPage> {
  static final log = Logger('BoardPage');

  /// Init timer handler.
  late Timer _initTimer;

  /// AI timer handle.
  Timer? _aiTimer;

  /// Current status in game.
  String _status = '';

  @override
  void initState() {
    super.initState();
    _initTimer = Timer(const Duration(), _handleInit);
    _status = getStatusString();
    log.fine('${this} initState()');
  }

  @override
  void dispose() {
    log.fine('${this} dispose()');
    _aiTimer?.cancel();
    _initTimer.cancel();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final board = widget.board;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.app),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // current status
            ColoredBox(
              color: Colors.yellow,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _status,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // board
            Expanded(
              child: GridView.count(
                crossAxisCount: game.Board.boardSize,
                children: _buildButtonList(context),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        var isBack = true;
        if (board.state == game.StateType.playing) {
          final result = await MessageBox.question(
            context,
            t.question.areYouSureToExit,
            MessageBoxOptions(
              button0Negative: true,
            ),
          );
          if (result != true) {
            isBack = false;
          }
        }
        return isBack;
      },
    );
  }

  List<Widget> _buildButtonList(BuildContext context) {
    const totalSize = game.Board.totalSize;
    var list = <Widget>[];
    for (var i = 0; i < totalSize; i++) {
      list.add(_buildButton(context, i));
    }
    return list;
  }

  Widget _buildButton(BuildContext context, int index) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 100,
        minHeight: 100,
        maxWidth: 200,
        maxHeight: 200,
      ),
      child: CustomPaint(
        painter: BorderPainter(
          board: widget.board,
          index: index,
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: _buildBlock(context, index),
        ),
      ),
    );
  }

  Widget _buildBlock(BuildContext context, int index) {
    final board = widget.board;
    var marker = board.moves[index];
    if (marker == null) {
      if (board.state == game.StateType.playing) {
        // playing and waiting
        return TextButton(
          child: CustomPaint(
            painter: BlockPainter(marker: null),
          ),
          onPressed: () => putMarker(context, index),
        );
      } else {
        // game over
        return const SizedBox.shrink();
      }
    } else {
      return CustomPaint(
        painter: BlockPainter(marker: marker),
      );
    }
  }

  // ----------------------------------------------------------------------

  Future<void> _handleInit() async {
    if (widget.board.firstMove == game.MarkerType.x) {
      checkNonHumanTurn();
    }
  }

  // ----------------------------------------------------------------------

  void checkNonHumanTurn() {
    if (widget.opponentType == OpponentType.computer ||
        widget.opponentType == OpponentType.network) {
      if (widget.board.state == game.StateType.playing) {
        _aiTimer = Timer(const Duration(), handleAi);
      }
    }
  }

  void putMarker(BuildContext context, int index) {
    setState(() {
      widget.board.put(index);
      _status = getStatusString();
    });
    checkNonHumanTurn();
  }

  Future<void> handleAi() async {
    int move = 0;
    if (widget.opponentType == OpponentType.computer) {
      // computer move
      move = await game.computerRandom(widget.board);
    } else if (widget.opponentType == OpponentType.network) {
      // network move
      final first = widget.board.firstMove == game.MarkerType.o ? 1 : 2;
      final uri = Uri.parse(
          'http://localhost:8080/ttt?first=$first&history=${widget.board.history}');
      try {
        final res = await http.get(uri);
        final index = int.parse(res.body);
        log.finest('move next from http: $index');
        move = index;
      } catch (ex) {
        log.finest('error, revert to computer');
        move = await game.computerRandom(widget.board);
      }
    }
    setState(() {
      widget.board.put(move);
      _status = getStatusString();
    });
  }

  // ----------------------------------------------------------------------

  String getStatusString() {
    final board = widget.board;

    switch (board.state) {
      case game.StateType.playing:
        final loc =
            board.marker == game.MarkerType.o ? t.boardPage.o : t.boardPage.x;
        return t.boardPage.turn(name: loc);

      case game.StateType.winner:
        final loc =
            board.marker == game.MarkerType.o ? t.boardPage.o : t.boardPage.x;
        return t.boardPage.win(name: loc);

      case game.StateType.draw:
        return t.boardPage.draw;
    }
  }
}
