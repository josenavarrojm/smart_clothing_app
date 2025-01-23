import 'package:shared_preferences/shared_preferences.dart';

/// Claves constantes para las preferencias compartidas.
const String _lastPageKey = 'last_page';
const String _alertsKey = 'alerts';

/// Guarda el nombre de la última página visitada.
Future<void> saveLastPage(String pageName) async {
  await _saveString(_lastPageKey, pageName);
}

/// Obtiene el nombre de la última página visitada.
Future<String?> getLastPage() async {
  return _getString(_lastPageKey);
}

/// Guarda las alertas.
Future<void> saveAlerts(String alerts) async {
  await _saveString(_alertsKey, alerts);
}

/// Obtiene las alertas guardadas.
Future<String?> getAlerts() async {
  return _getString(_alertsKey);
}

/// Guarda una cadena de texto en las preferencias compartidas.
///
/// [key] es la clave para identificar el valor.
/// [value] es el valor que se desea guardar.
Future<void> _saveString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

/// Obtiene una cadena de texto de las preferencias compartidas.
///
/// [key] es la clave para identificar el valor.
/// Retorna el valor asociado o `null` si no existe.
Future<String?> _getString(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
