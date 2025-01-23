import 'package:flutter/material.dart';

/// `InternetConnectionNotifier` es un singleton que gestiona el estado
/// de la conexión a internet y a MongoDB en la aplicación.
///
/// Implementa el patrón `ChangeNotifier` para notificar cambios a los listeners.
class InternetConnectionNotifier with ChangeNotifier {
  // Singleton
  static final InternetConnectionNotifier _instance =
      InternetConnectionNotifier._internal();
  factory InternetConnectionNotifier() => _instance;
  InternetConnectionNotifier._internal();

  // Propiedades privadas
  bool _internetConnectionState = false;
  bool _mongoDBConnectionState = false;

  // Getters: Proveen acceso de solo lectura al estado.
  bool get internetConnectionState => _internetConnectionState;
  bool get mongoDBConnectionState => _mongoDBConnectionState;

  // Método genérico para actualizar el estado y notificar a los listeners.
  void _updateConnectionState(bool status, void Function(bool) updater) {
    updater(status);
    notifyListeners();
  }

  /// Actualiza el estado de conexión a internet.
  void updateInternetConnectionState(bool status) => _updateConnectionState(
      status, (value) => _internetConnectionState = value);

  /// Actualiza el estado de conexión a MongoDB.
  void updateMongoDBConnectionState(bool status) => _updateConnectionState(
      status, (value) => _mongoDBConnectionState = value);
}
