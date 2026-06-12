import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppLocaleStore {
  Future<Locale?> load();

  Future<void> save(Locale locale);
}

class SharedPreferencesAppLocaleStore implements AppLocaleStore {
  SharedPreferencesAppLocaleStore(this._preferences);

  static const _localeKey = 'brain_up.app_locale.v1';

  final SharedPreferences _preferences;

  @override
  Future<Locale?> load() async {
    final languageCode = _preferences.getString(_localeKey);
    if (languageCode == null || languageCode.isEmpty) {
      return null;
    }

    return Locale(languageCode);
  }

  @override
  Future<void> save(Locale locale) async {
    await _preferences.setString(_localeKey, locale.languageCode);
  }
}
