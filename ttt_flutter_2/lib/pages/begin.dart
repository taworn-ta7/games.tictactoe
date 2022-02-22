import 'dart:async';
import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../game/game.dart' as game;
import '../widgets/title_painter.dart';
import '../loggings.dart';
import '../styles.dart';
import '../app_shared.dart';
import '../pages.dart';
import '../pages/board.dart';

/// BeginPage class.
class BeginPage extends StatefulWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  _BeginState createState() => _BeginState();
}

/// _BeginState internal class.
class _BeginState extends State<BeginPage> {
  static final log = Logger('BeginPage');

  // widgets
  final _formKey = GlobalKey<FormState>();
  var _firstMove = game.MarkerType.o;

  @override
  void initState() {
    super.initState();
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.beginPage;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.videogame_asset),
        title: Text(tr.title),
        actions: [
          // Thai language
          IconButton(
            icon: Image.asset('assets/locales/th.png'),
            tooltip: t.switchLocale.th,
            onPressed: () => setState(
              () => AppShared.instance().changeLocale(context, 'th'),
            ),
          ),

          // English language
          IconButton(
            icon: Image.asset('assets/locales/en.png'),
            tooltip: t.switchLocale.en,
            onPressed: () => setState(
              () => AppShared.instance().changeLocale(context, 'en'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Styles.around(
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // title
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: CustomPaint(
                    painter: TitlePainter(),
                    size: const Size(256, 256),
                  ),
                ),
                Styles.betweenVerticalBigger(),

                // o start
                RadioListTile<game.MarkerType>(
                  title: Text(tr.startWithO),
                  value: game.MarkerType.o,
                  groupValue: _firstMove,
                  onChanged: (value) =>
                      setState(() => _firstMove = value ?? game.MarkerType.o),
                ),
                // x start
                RadioListTile<game.MarkerType>(
                  title: Text(tr.startWithX),
                  value: game.MarkerType.x,
                  groupValue: _firstMove,
                  onChanged: (value) =>
                      setState(() => _firstMove = value ?? game.MarkerType.x),
                ),
                Styles.betweenVerticalBigger(),

                // player vs player
                ElevatedButton.icon(
                  icon: const Icon(Icons.gamepad),
                  label: Styles.buttonPadding(Text(tr.playerVsPlayer)),
                  onPressed: () => _begin(type: OpponentType.player),
                ),
                Styles.betweenVertical(),

                // player vs computer
                ElevatedButton.icon(
                  icon: const Icon(Icons.computer),
                  label: Styles.buttonPadding(Text(tr.playerVsComputer)),
                  onPressed: () => _begin(type: OpponentType.computer),
                ),
                Styles.betweenVertical(),

                // player vs net
                ElevatedButton.icon(
                  icon: const Icon(Icons.casino),
                  label: Styles.buttonPadding(Text(tr.playerVsNetwork)),
                  onPressed: () => _begin(type: OpponentType.network),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  Future<void> _begin({required OpponentType type}) async {
    // enter system
    AppShared.instance().begin(context);

    // switch page
    await Pages.switchPage(
      context,
      BoardPage(
        board: game.Board(firstMove: _firstMove),
        opponentType: type,
      ),
    );
  }
}
