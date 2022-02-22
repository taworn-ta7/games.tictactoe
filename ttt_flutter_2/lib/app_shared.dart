import 'package:flutter/material.dart';
import './loggings.dart';
import './i18n/strings.g.dart';
import './app.dart';

/// AppShared singleton class.
class AppShared {
  static AppShared? _instance;

  static AppShared instance() {
    _instance ??= AppShared();
    return _instance!;
  }

  // ----------------------------------------------------------------------

  static final log = Logger('AppShared');

  /// Construction.
  AppShared();

  // ----------------------------------------------------------------------

  //
  // Localization
  //

  /// Supported locale list.
  final localeList = const [
    Locale('en'),
    Locale('th'),
  ];

  /// Current locale.
  Locale get currentLocale => localeList[_indexLocale];
  int _indexLocale = 0;

  /// Change current locale.
  void changeLocale(BuildContext context, String locale) {
    late int i;
    switch (locale) {
      case 'th':
        i = 1;
        break;

      case 'en':
      case '':
      default:
        i = 0;
        break;
    }

    if (_indexLocale != i) {
      _indexLocale = i;
      log.info('change locale to $locale');
      LocaleSettings.setLocaleRaw(locale);
      App.refresh(context);
    }
  }

  // ----------------------------------------------------------------------

  //
  // Theme
  //

  /// Material color list.
  static List<MaterialColor> themeList = [
    Colors.lime,
  ];

  /// Current theme.
  MaterialColor get currentTheme => themeList[_indexTheme];
  int _indexTheme = 0;

  /// Change current theme.
  void changeTheme(BuildContext context, int index) {
    if (index < 0 || index >= themeList.length) return;

    if (_indexTheme != index) {
      _indexTheme = index;
      log.info('change theme to $_indexTheme');

      App.refresh(context);
    }
  }

  // ----------------------------------------------------------------------

  /// Begin task.
  void begin(
    BuildContext context,
  ) async {
    log.info('begin to system, welcome :)');
  }

  /// End task.
  void end(
    BuildContext context,
  ) async {
    // move out to first page
    Navigator.popUntil(context, (route) => route.isFirst);
    log.info('end from system gracefully :)');
  }
}
