import 'package:flutter/material.dart';

abstract class AppLanguage {
  final String languageCode;
  final String countryCode;
  final Locale _locale;

  Locale get locale => _locale;

  AppLanguage(
    this.languageCode,
    this.countryCode,
  ) : _locale = Locale(languageCode);
}
