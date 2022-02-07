import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';
import '../i18n/strings.g.dart';
import '../game/game.dart' as game;
import '../constants.dart';
import '../ui.dart';

class BoardStart {
  /// Big board size:
  /// - false: 3x3
  /// - true: 4x4.
  final bool bigBoardSize;

  /// Play with computer or human.
  final bool playWithComputer;

  BoardStart({
    required this.bigBoardSize,
    required this.playWithComputer,
  });
}

// ----------------------------------------------------------------------

class BoardPage extends StatefulWidget {
  final game.Board board;
  final bool withComputer;

  const BoardPage({
    Key? key,
    required this.board,
    required this.withComputer,
  }) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<BoardPage> {
  static final log = Logger('BoardPage');

  /// Player 2 is computer or not.
  bool _isComputer = false;

  /// AI timer handle.
  Timer? _aiTimer;

  /// Current status in game.
  String _status = '';

  @override
  void initState() {
    super.initState();
    _isComputer = widget.withComputer;
    _status = getStatusString();
    log.fine('${this} initState()');
  }

  @override
  void dispose() {
    log.fine('${this} dispose()');
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
                padding: const EdgeInsets.all(
                  Constants.distanceBig,
                ),
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
                crossAxisCount: board.boardSize,
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
    final totalSize = widget.board.totalSize;
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
          padding: const EdgeInsets.all(Constants.distanceHuge),
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

  void putMarker(BuildContext context, int index) {
    setState(() {
      widget.board.put(index);
      _status = getStatusString();
    });

    if (_isComputer) {
      if (widget.board.state == game.StateType.playing) {
        _aiTimer = Timer(const Duration(), handleAi);
      }
    }
  }

  Future<void> handleAi() async {
    final board = widget.board;

    // random how to move
    final random = Random();
    var value = random.nextInt(100);
    var index = 0;
    while (true) {
      if (value > 0) {
        index++;
        if (index >= board.totalSize) {
          index = 0;
        }
        value--;
      } else {
        if (board.moves[index] != null) {
          index++;
          if (index >= board.totalSize) {
            index = 0;
          }
        } else {
          break;
        }
      }
    }

    setState(() {
      board.put(index);
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
