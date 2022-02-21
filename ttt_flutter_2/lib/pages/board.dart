import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../game/game.dart' as game;
import '../widgets/message_box.dart';
import '../widgets/block_painter.dart';
import '../widgets/border_painter.dart';
import '../loggings.dart';

class BoardPage extends StatefulWidget {
  final game.Board board;
  final bool computerBegin;

  const BoardPage({
    Key? key,
    required this.board,
    required this.computerBegin,
  }) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<BoardPage> {
  static final log = Logger('BoardPage');

  /// Player 2 is computer or not.
  late bool _isComputerBegin;

  /// AI timer handle.
  Timer? _aiTimer;

  /// Current status in game.
  String _status = '';

  /// Init timer handler.
  late Timer _initTimer;

  @override
  void initState() {
    super.initState();
    _isComputerBegin = widget.computerBegin;
    _status = getStatusString();
    _initTimer = Timer(const Duration(), _handleInit);
    log.fine('${this} initState()');
  }

  @override
  void dispose() {
    log.fine('${this} dispose()');
    _initTimer.cancel();
    _aiTimer?.cancel();
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
        minWidth: 160,
        minHeight: 160,
        maxWidth: 250,
        maxHeight: 250,
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
    if (_isComputerBegin) {
      if (widget.board.state == game.StateType.playing) {
        _aiTimer = Timer(const Duration(), handleAi);
      }
    }
  }

  // ----------------------------------------------------------------------

  void putMarker(BuildContext context, int index) {
    setState(() {
      widget.board.put(index);
      _status = getStatusString();
    });

    if (widget.board.state == game.StateType.playing) {
      _aiTimer = Timer(const Duration(), handleAi);
    }
  }

  Future<void> handleAi() async {
    int move = await game.computerRandom(widget.board);
    setState(() {
      widget.board.put(move);
      _status = getStatusString();
    });
  }

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
