import 'package:flutter/material.dart';

/// [AlertsNotifier] es un gestor de notificaciones que permite actualizar
/// y notificar cambios en el estado de las alertas dentro de la aplicación.
class AlertsNotifier with ChangeNotifier {
  // Implementación de patrón Singleton para garantizar una única instancia.
  static final AlertsNotifier _instance = AlertsNotifier._internal();
  factory AlertsNotifier() => _instance;
  AlertsNotifier._internal();

  // Almacena el estado actual de las alertas.
  String _newAlerts = '';

  /// Obtiene el estado actual de las nuevas alertas.
  String get newAlerts => _newAlerts;

  /// Actualiza el estado de las nuevas alertas y notifica a los oyentes.
  ///
  /// [status]: Nuevo estado de las alertas.
  void updateNewAlerts(String status) {
    _newAlerts = status;
    notifyListeners(); // Notifica a los widgets interesados.
  }
}
