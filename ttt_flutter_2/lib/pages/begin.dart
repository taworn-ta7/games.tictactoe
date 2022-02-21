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
              mainAxisAlignment: MainAxisAlignment.start,
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

                // begin with player
                ElevatedButton.icon(
                  icon: const Icon(Icons.gamepad),
                  label: Styles.buttonPadding(Text(tr.playerBegin)),
                  onPressed: () {
                    _begin();
                  },
                ),
                Styles.betweenVertical(),

                // begin with computer
                ElevatedButton.icon(
                  icon: const Icon(Icons.casino),
                  label: Styles.buttonPadding(Text(tr.computerBegin)),
                  onPressed: () {
                    _begin(computerBegin: true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  Future<void> _begin({bool computerBegin = false}) async {
    // enter system
    AppShared.instance().begin(context, board: game.Board());

    // switch page
    await Pages.switchPage(
      context,
      BoardPage(
        board: game.Board(),
        computerBegin: computerBegin,
      ),
    );
  }
}
