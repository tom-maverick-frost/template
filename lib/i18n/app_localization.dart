import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template/i18n/languages/english_language.dart';
import 'package:template/i18n/languages/german_language.dart';

class AppLocalization extends ChangeNotifier {
  static const _I18N = 'i18n';
  static const _JSON = '.json';
  static const _EMPTY = '';

  static AppLocalization? _instance;

  static AppLocalization get instance => _instance!;

  Locale _locale;
  Map<String, String> _translations = {};

  String get code => _locale.languageCode;

  String translate(String key) {
    return _translations[key] ?? _EMPTY;
  }

  AppLocalization._(this._locale);

  factory AppLocalization() {
    if (_instance == null) {
      _instance = AppLocalization._(EnglishLanguage().locale);

      log('INSIDE INITIALIZATION');
    }

    return _instance!;
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_locale == locale) {
      return;
    }

    _locale = locale;

    await load();

    notifyListeners();
  }

  Future<void> load() async {
    final jsonString = await rootBundle.loadString(
      '$_I18N/${_locale.languageCode}$_JSON',
    );

    final jsonMap = json.decode(jsonString);

    _translations = _flattenTranslations(jsonMap);
  }

  Map<String, String> _flattenTranslations(
    Map<String, dynamic> jsonMap, [
    String prefix = '',
  ]) {
    final Map<String, String> translations = {};

    jsonMap.forEach((key, value) {
      if (value is Map) {
        translations.addAll(
          _flattenTranslations(
            value as Map<String, dynamic>,
            '$prefix$key.',
          ),
        );
      } else {
        translations['$prefix$key'] = value.toString();
      }
    });

    return translations;
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();
  static final _english = EnglishLanguage();
  static final _german = GermanLanguage();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == _english.languageCode ||
        locale.languageCode == _german.languageCode;
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    return Future.value(AppLocalization());
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}
