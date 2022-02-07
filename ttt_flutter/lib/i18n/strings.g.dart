
/*
 * Generated file. Do not edit.
 * 
 * Locales: 2
 * Strings: 44 (22.0 per locale)
 * 
 * Built on 2021-09-20 at 21:46 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale {
	en, // 'en' (base locale, fallback)
	th, // 'th'
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.useDeviceLocale().languageTag
	static AppLocale useDeviceLocale() {
		final String? deviceLocale = WidgetsBinding.instance?.window.locale.toLanguageTag();
		if (deviceLocale != null) {
			return setLocaleRaw(deviceLocale);
		} else {
			return setLocale(_baseLocale);
		}
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

		if (WidgetsBinding.instance != null) {
			// force rebuild if TranslationProvider is used
			_translationProviderKey.currentState?.setLocale(_currLocale);
		}

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String localeRaw) {
		final selected = _selectLocale(localeRaw);
		return setLocale(selected ?? _baseLocale);
	}

	/// Gets current locale.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.currentLocale.languageTag
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.baseLocale.languageTag
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}

}

// context enums

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {
	_StringsEn get translations {
		switch (this) {
			case AppLocale.en: return _StringsEn._instance;
			case AppLocale.th: return _StringsTh._instance;
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
			case AppLocale.th: return 'th';
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return const Locale.fromSubtags(languageCode: 'en');
			case AppLocale.th: return const Locale.fromSubtags(languageCode: 'th');
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
			case 'th': return AppLocale.th;
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	final _StringsEn translations; // store translations to avoid switch call
	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization feature not used

// helpers

final _localeRegex = RegExp(r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);
		final country = match.group(5);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}

		if (selected == null && country != null) {
			// match country
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.contains(country) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

class _StringsEn {
	_StringsEn._(); // no constructor

	static final _StringsEn _instance = _StringsEn._();

	String get app => 'Tic-Tac-Toe';
	_StringsCommonEn get common => _StringsCommonEn._instance;
	_StringsSwitchLocaleEn get switchLocale => _StringsSwitchLocaleEn._instance;
	_StringsQuestionEn get question => _StringsQuestionEn._instance;
	_StringsMessageBoxEn get messageBox => _StringsMessageBoxEn._instance;
	_StringsStartPageEn get startPage => _StringsStartPageEn._instance;
	_StringsBoardPageEn get boardPage => _StringsBoardPageEn._instance;

	/// A flat map containing all translations.
	dynamic operator[](String key) {
		return _translationMap[AppLocale.en]![key];
	}
}

class _StringsCommonEn {
	_StringsCommonEn._(); // no constructor

	static final _StringsCommonEn _instance = _StringsCommonEn._();

	String get close => 'Close';
	String get ok => 'OK';
	String get cancel => 'Cancel';
	String get yes => 'Yes';
	String get no => 'No';
	String get retry => 'Retry';
}

class _StringsSwitchLocaleEn {
	_StringsSwitchLocaleEn._(); // no constructor

	static final _StringsSwitchLocaleEn _instance = _StringsSwitchLocaleEn._();

	String get english => 'English';
	String get thai => 'ไทย';
}

class _StringsQuestionEn {
	_StringsQuestionEn._(); // no constructor

	static final _StringsQuestionEn _instance = _StringsQuestionEn._();

	String get areYouSureToExit => 'Are you sure to exit this game?';
}

class _StringsMessageBoxEn {
	_StringsMessageBoxEn._(); // no constructor

	static final _StringsMessageBoxEn _instance = _StringsMessageBoxEn._();

	_StringsMessageBoxInfoEn get info => _StringsMessageBoxInfoEn._instance;
	_StringsMessageBoxWarningEn get warning => _StringsMessageBoxWarningEn._instance;
	_StringsMessageBoxErrorEn get error => _StringsMessageBoxErrorEn._instance;
	_StringsMessageBoxQuestionEn get question => _StringsMessageBoxQuestionEn._instance;
}

class _StringsStartPageEn {
	_StringsStartPageEn._(); // no constructor

	static final _StringsStartPageEn _instance = _StringsStartPageEn._();

	String get boardSize => 'Board Size';
	String get playWithHuman => 'Play with Human';
	String get playWithComputer => 'Play with Computer';
}

class _StringsBoardPageEn {
	_StringsBoardPageEn._(); // no constructor

	static final _StringsBoardPageEn _instance = _StringsBoardPageEn._();

	String get o => 'O';
	String get x => 'X';
	String turn({required Object name}) => '$name Turn';
	String win({required Object name}) => '$name is Win :)';
	String get draw => 'Draw!';
}

class _StringsMessageBoxInfoEn {
	_StringsMessageBoxInfoEn._(); // no constructor

	static final _StringsMessageBoxInfoEn _instance = _StringsMessageBoxInfoEn._();

	String get title => 'Information';
}

class _StringsMessageBoxWarningEn {
	_StringsMessageBoxWarningEn._(); // no constructor

	static final _StringsMessageBoxWarningEn _instance = _StringsMessageBoxWarningEn._();

	String get title => 'Warning';
}

class _StringsMessageBoxErrorEn {
	_StringsMessageBoxErrorEn._(); // no constructor

	static final _StringsMessageBoxErrorEn _instance = _StringsMessageBoxErrorEn._();

	String get title => 'Error';
}

class _StringsMessageBoxQuestionEn {
	_StringsMessageBoxQuestionEn._(); // no constructor

	static final _StringsMessageBoxQuestionEn _instance = _StringsMessageBoxQuestionEn._();

	String get title => 'Question';
}

class _StringsTh implements _StringsEn {
	_StringsTh._(); // no constructor

	static final _StringsTh _instance = _StringsTh._();

	@override String get app => 'โอ-เอ็กซ์';
	@override _StringsCommonTh get common => _StringsCommonTh._instance;
	@override _StringsSwitchLocaleTh get switchLocale => _StringsSwitchLocaleTh._instance;
	@override _StringsQuestionTh get question => _StringsQuestionTh._instance;
	@override _StringsMessageBoxTh get messageBox => _StringsMessageBoxTh._instance;
	@override _StringsStartPageTh get startPage => _StringsStartPageTh._instance;
	@override _StringsBoardPageTh get boardPage => _StringsBoardPageTh._instance;

	/// A flat map containing all translations.
	@override
	dynamic operator[](String key) {
		return _translationMap[AppLocale.th]![key];
	}
}

class _StringsCommonTh implements _StringsCommonEn {
	_StringsCommonTh._(); // no constructor

	static final _StringsCommonTh _instance = _StringsCommonTh._();

	@override String get close => 'ปิด';
	@override String get ok => 'ตกลง';
	@override String get cancel => 'ยกเลิก';
	@override String get yes => 'ใช่';
	@override String get no => 'ไม่ใช่';
	@override String get retry => 'ลองใหม่';
}

class _StringsSwitchLocaleTh implements _StringsSwitchLocaleEn {
	_StringsSwitchLocaleTh._(); // no constructor

	static final _StringsSwitchLocaleTh _instance = _StringsSwitchLocaleTh._();

	@override String get english => 'English';
	@override String get thai => 'ไทย';
}

class _StringsQuestionTh implements _StringsQuestionEn {
	_StringsQuestionTh._(); // no constructor

	static final _StringsQuestionTh _instance = _StringsQuestionTh._();

	@override String get areYouSureToExit => 'คุณแน่ใจที่จะออกจากเกมนี้หรือไม่?';
}

class _StringsMessageBoxTh implements _StringsMessageBoxEn {
	_StringsMessageBoxTh._(); // no constructor

	static final _StringsMessageBoxTh _instance = _StringsMessageBoxTh._();

	@override _StringsMessageBoxInfoTh get info => _StringsMessageBoxInfoTh._instance;
	@override _StringsMessageBoxWarningTh get warning => _StringsMessageBoxWarningTh._instance;
	@override _StringsMessageBoxErrorTh get error => _StringsMessageBoxErrorTh._instance;
	@override _StringsMessageBoxQuestionTh get question => _StringsMessageBoxQuestionTh._instance;
}

class _StringsStartPageTh implements _StringsStartPageEn {
	_StringsStartPageTh._(); // no constructor

	static final _StringsStartPageTh _instance = _StringsStartPageTh._();

	@override String get boardSize => 'ขนาดกระดาน';
	@override String get playWithHuman => 'เล่นกับคน';
	@override String get playWithComputer => 'เล่นกับคอมพิวเตอร์';
}

class _StringsBoardPageTh implements _StringsBoardPageEn {
	_StringsBoardPageTh._(); // no constructor

	static final _StringsBoardPageTh _instance = _StringsBoardPageTh._();

	@override String get o => 'โอ';
	@override String get x => 'เอ็กซ์';
	@override String turn({required Object name}) => 'ตา $name';
	@override String win({required Object name}) => '$name เป็นผู้ชนะ :)';
	@override String get draw => 'เสมอ!';
}

class _StringsMessageBoxInfoTh implements _StringsMessageBoxInfoEn {
	_StringsMessageBoxInfoTh._(); // no constructor

	static final _StringsMessageBoxInfoTh _instance = _StringsMessageBoxInfoTh._();

	@override String get title => 'ข้อมูลข่าวสาร';
}

class _StringsMessageBoxWarningTh implements _StringsMessageBoxWarningEn {
	_StringsMessageBoxWarningTh._(); // no constructor

	static final _StringsMessageBoxWarningTh _instance = _StringsMessageBoxWarningTh._();

	@override String get title => 'แจ้งเตือน';
}

class _StringsMessageBoxErrorTh implements _StringsMessageBoxErrorEn {
	_StringsMessageBoxErrorTh._(); // no constructor

	static final _StringsMessageBoxErrorTh _instance = _StringsMessageBoxErrorTh._();

	@override String get title => 'เกิดข้อผิดพลาด';
}

class _StringsMessageBoxQuestionTh implements _StringsMessageBoxQuestionEn {
	_StringsMessageBoxQuestionTh._(); // no constructor

	static final _StringsMessageBoxQuestionTh _instance = _StringsMessageBoxQuestionTh._();

	@override String get title => 'คำถาม';
}

/// A flat map containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
late Map<AppLocale, Map<String, dynamic>> _translationMap = {
	AppLocale.en: {
		'app': 'Tic-Tac-Toe',
		'common.close': 'Close',
		'common.ok': 'OK',
		'common.cancel': 'Cancel',
		'common.yes': 'Yes',
		'common.no': 'No',
		'common.retry': 'Retry',
		'switchLocale.english': 'English',
		'switchLocale.thai': 'ไทย',
		'question.areYouSureToExit': 'Are you sure to exit this game?',
		'messageBox.info.title': 'Information',
		'messageBox.warning.title': 'Warning',
		'messageBox.error.title': 'Error',
		'messageBox.question.title': 'Question',
		'startPage.boardSize': 'Board Size',
		'startPage.playWithHuman': 'Play with Human',
		'startPage.playWithComputer': 'Play with Computer',
		'boardPage.o': 'O',
		'boardPage.x': 'X',
		'boardPage.turn': ({required Object name}) => '$name Turn',
		'boardPage.win': ({required Object name}) => '$name is Win :)',
		'boardPage.draw': 'Draw!',
	},
	AppLocale.th: {
		'app': 'โอ-เอ็กซ์',
		'common.close': 'ปิด',
		'common.ok': 'ตกลง',
		'common.cancel': 'ยกเลิก',
		'common.yes': 'ใช่',
		'common.no': 'ไม่ใช่',
		'common.retry': 'ลองใหม่',
		'switchLocale.english': 'English',
		'switchLocale.thai': 'ไทย',
		'question.areYouSureToExit': 'คุณแน่ใจที่จะออกจากเกมนี้หรือไม่?',
		'messageBox.info.title': 'ข้อมูลข่าวสาร',
		'messageBox.warning.title': 'แจ้งเตือน',
		'messageBox.error.title': 'เกิดข้อผิดพลาด',
		'messageBox.question.title': 'คำถาม',
		'startPage.boardSize': 'ขนาดกระดาน',
		'startPage.playWithHuman': 'เล่นกับคน',
		'startPage.playWithComputer': 'เล่นกับคอมพิวเตอร์',
		'boardPage.o': 'โอ',
		'boardPage.x': 'เอ็กซ์',
		'boardPage.turn': ({required Object name}) => 'ตา $name',
		'boardPage.win': ({required Object name}) => '$name เป็นผู้ชนะ :)',
		'boardPage.draw': 'เสมอ!',
	},
};
