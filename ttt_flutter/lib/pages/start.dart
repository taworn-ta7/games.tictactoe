import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:page_transition/page_transition.dart';
import '../i18n/strings.g.dart';
import '../game/game.dart' as game;
import '../constants.dart';
import '../ui.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<StartPage> {
  static final log = Logger('StartPage');

  bool _bigBoardSize = false;

  @override
  void initState() {
    super.initState();
    log.fine('${this} initState()');
  }

  @override
  void dispose() {
    log.fine('${this} dispose()');
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.startPage;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.app),
        actions: [
          // Thai language
          IconButton(
            icon: Image.asset('images/th.png'),
            tooltip: t.switchLocale.thai,
            onPressed: () {
              LocaleSettings.setLocaleRaw('th');
              setState(() {});
            },
          ),

          // English language
          IconButton(
            icon: Image.asset('images/en.png'),
            tooltip: t.switchLocale.english,
            onPressed: () {
              LocaleSettings.setLocaleRaw('en');
              setState(() {});
            },
          ),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(Constants.distanceLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // title
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(Constants.distanceMedium),
                  child: CustomPaint(
                    painter: TitlePainter(),
                    size: const Size(256, 256),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(
                    top: Constants.distanceNormal,
                    bottom: Constants.distanceSmall,
                  ),
                  child: Text(tr.boardSize),
                ),

                // 3x3
                RadioListTile<bool>(
                  title: const Text('3 x 3'),
                  value: false,
                  groupValue: _bigBoardSize,
                  onChanged: (value) =>
                      setState(() => _bigBoardSize = value ?? false),
                ),

                // 4x4
                RadioListTile<bool>(
                  title: const Text('4 x 4'),
                  value: true,
                  groupValue: _bigBoardSize,
                  onChanged: (value) =>
                      setState(() => _bigBoardSize = value ?? true),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: Constants.distanceNormal),
                ),

                // play with computer
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.distanceMedium),
                    child: Text(tr.playWithComputer),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: BoardPage(
                        board: game.Board(bigBoardSize: _bigBoardSize),
                        withComputer: true,
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: Constants.distanceNormal),
                ),

                // play with human
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.distanceMedium),
                    child: Text(tr.playWithHuman),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: BoardPage(
                        board: game.Board(bigBoardSize: _bigBoardSize),
                        withComputer: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
