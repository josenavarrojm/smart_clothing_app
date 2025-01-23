import 'package:flutter/material.dart';

/// [BleConnectionService] gestiona el estado de la conexión Bluetooth,
/// así como los eventos asociados, como la suscripción, dispositivos encontrados,
/// y estado del escaneo y BLE.
class BleConnectionService with ChangeNotifier {
  // Implementación de patrón Singleton para garantizar una única instancia.
  static final BleConnectionService _instance =
      BleConnectionService._internal();
  factory BleConnectionService() => _instance;
  BleConnectionService._internal();

  // Variables privadas para el estado interno.
  bool _isConnected = false;
  bool _isSuscripted = false;
  bool _deviceFound = false;
  bool _lostConnection = false;
  bool _scanned = false;
  bool _bleStatus = false;

  /// Obtiene el estado de la conexión BLE.
  bool get isConnected => _isConnected;

  /// Obtiene el estado de si se encontró un dispositivo.
  bool get deviceFound => _deviceFound;

  /// Indica si la conexión se perdió.
  bool get lostConnection => _lostConnection;

  /// Indica si el escaneo ha sido completado.
  bool get scanned => _scanned;

  /// Obtiene el estado actual de BLE.
  bool get bleStatus => _bleStatus;

  /// Obtiene el estado de la suscripción.
  bool get isSuscripted => _isSuscripted;

  /// Actualiza el estado de la conexión BLE y notifica a los oyentes.
  ///
  /// [status]: Nuevo estado de la conexión (conectado/desconectado).
  void updateConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }

  /// Actualiza el estado de los dispositivos encontrados y notifica a los oyentes.
  ///
  /// [status]: Nuevo estado de los dispositivos encontrados (true/false).
  void updateDeviceStatus(bool status) {
    _deviceFound = status;
    notifyListeners();
  }

  /// Actualiza el estado de pérdida de conexión y notifica a los oyentes.
  ///
  /// [status]: Nuevo estado de pérdida de conexión (true/false).
  void updateLostConnection(bool status) {
    _lostConnection = status;
    notifyListeners();
  }

  /// Actualiza el estado de la suscripción y notifica a los oyentes.
  ///
  /// [status]: Nuevo estado de suscripción (true/false).
  void updateSuscriptionStatus(bool status) {
    _isSuscripted = status;
    notifyListeners();
  }

  /// Actualiza el estado del escaneo y notifica a los oyentes.
  ///
  /// [status]: Nuevo estado del escaneo (true/false).
  void updateScanned(bool status) {
    _scanned = status;
    notifyListeners();
  }

  /// Actualiza el estado general de BLE y notifica a los oyentes.
  ///
  /// [status]: Nuevo estado de BLE (true/false).
  void updateBleStatus(bool status) {
    _bleStatus = status;
    notifyListeners();
  }
}
