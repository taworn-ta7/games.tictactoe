import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'i18n/strings.g.dart';
import 'pages/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  LocaleSettings.setLocaleRaw('en');

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    // ignore: avoid_print
    (record) => print(
      '${record.time} ${record.level.name.padRight(7)} ${record.loggerName.padRight(12).characters.take(12)} ${record.message}',
    ),
  );

  runApp(const App());
}

// ----------------------------------------------------------------------

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: LocaleSettings.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (context) => const StartPage(),
      },
      initialRoute: '/',
      title: t.app,
    );
  }
}
