import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  bool _loginBtn = false;

  bool get loginBtn => _loginBtn;

  void toggleLoginBtn() {
    _loginBtn = !_loginBtn;
    notifyListeners(); // Notifica a los widgets que dependen de este estado
  }

  void setLoginBtn(bool value) {
    _loginBtn = value;
    notifyListeners();
  }
}
