import 'package:flutter/material.dart';

class AlertsNotifier with ChangeNotifier {
  static final AlertsNotifier _instance = AlertsNotifier._internal();
  factory AlertsNotifier() => _instance;
  AlertsNotifier._internal();

  String _newAlerts = '';

  String get newAlerts => _newAlerts;

  void updateNewAlerts(String status) {
    _newAlerts = status;
    notifyListeners();
  }
}
