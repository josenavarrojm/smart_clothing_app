import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isLightTheme = true;

  ThemeNotifier() {
    _loadTheme();
  }

  bool get isLightTheme => _isLightTheme;

  toggleTheme(bool isOn) async {
    _isLightTheme = isOn;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeApp', isOn);
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLightTheme = prefs.getBool('themeApp') ?? true;
    notifyListeners();
  }
}
