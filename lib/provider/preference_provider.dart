import 'package:flutter/material.dart';

import '../common/styles.dart';
import '../data/preferences/preference_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    _getDailyRestoPreferences();
  }

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isDailyRestoActive = false;
  bool get isDailyRestoActive => _isDailyRestoActive;

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void _getDailyRestoPreferences() async {
    _isDailyRestoActive = await preferencesHelper.isDailyRestoActive;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }

  void enableDailyResto(bool value) {
    preferencesHelper.setDailyResto(value);
    _getDailyRestoPreferences();
  }
}
