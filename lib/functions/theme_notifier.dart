import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase para gestionar el tema de la aplicación (light o dark).
///
/// Implementa `ChangeNotifier` para permitir la actualización de widgets
/// que dependen del estado del tema.
class ThemeNotifier with ChangeNotifier {
  bool _isLightTheme = true;

  /// Constructor que carga el tema guardado al inicializarse.
  ThemeNotifier() {
    _loadTheme();
  }

  /// Obtiene el estado actual del tema.
  /// `true` indica tema claro, `false` indica tema oscuro.
  bool get isLightTheme => _isLightTheme;

  /// Alterna el tema entre claro y oscuro.
  ///
  /// [isOn] indica si el tema claro está activado.
  Future<void> toggleTheme(bool isOn) async {
    _isLightTheme = isOn;
    notifyListeners();
    await _saveTheme(isOn);
  }

  /// Carga el tema guardado desde las preferencias compartidas.
  Future<void> _loadTheme() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _isLightTheme = prefs.getBool('themeApp') ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint("Error al cargar el tema: $e");
    }
  }

  /// Guarda el estado del tema en las preferencias compartidas.
  Future<void> _saveTheme(bool isOn) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('themeApp', isOn);
    } catch (e) {
      debugPrint("Error al guardar el tema: $e");
    }
  }
}
