import 'package:flutter/material.dart';

/// `AuthState` gestiona el estado del botón de login en la aplicación.
///
/// Implementa el patrón `ChangeNotifier` para notificar cambios a los widgets
/// que dependen de este estado.
class AuthState extends ChangeNotifier {
  bool _loginBtn = false;

  /// Obtiene el estado actual del botón de login.
  bool get loginBtn => _loginBtn;

  /// Alterna el estado del botón de login.
  void toggleLoginBtn() {
    _loginBtn = !_loginBtn;
    notifyListeners();
  }

  /// Establece un nuevo estado para el botón de login.
  /// Si el valor es igual al actual, no se realizan notificaciones.
  void setLoginBtn(bool value) {
    if (_loginBtn != value) {
      _loginBtn = value;
      notifyListeners();
    }
  }
}
