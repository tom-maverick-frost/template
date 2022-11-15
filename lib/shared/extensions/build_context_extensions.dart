import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:template/i18n/app_localization.dart';

extension BuildContextExtensions on BuildContext {
  static const _ERRO_LABEL = 'ERROR_LABEL';

  String getLabel(String key) {
    final translation = AppLocalization.of(this).translate(key);

    if (translation == null) {
      // TODO: Log Error
      log('log error/extepion');

      return _ERRO_LABEL;
    }

    return translation;
  }
}
