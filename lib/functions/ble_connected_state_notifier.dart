// connection_service.dart
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class BleConnectionService with ChangeNotifier {
  static final BleConnectionService _instance =
      BleConnectionService._internal();
  factory BleConnectionService() => _instance;
  BleConnectionService._internal();
  //  {
  //   _loadSuscriptionState();
  // }

  bool _isConnected = false;
  bool _isSuscripted = false;
  bool _deviceFound = false;
  bool _lostConnection = false;
  bool _scanned = false;
  bool _bleStatus = false;

  bool get isConnected => _isConnected;
  bool get deviceFound => _deviceFound;
  bool get lostConnection => _lostConnection;
  bool get scanned => _scanned;
  bool get bleStatus => _bleStatus;

  void updateConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }

  void updateDeviceStatus(bool status) {
    _deviceFound = status;
    notifyListeners();
  }

  void updateLostConnection(bool status) {
    _lostConnection = status;
    notifyListeners();
  }

  bool get isSuscripted => _isSuscripted;

  void updateSuscriptionStatus(bool status) {
    _isSuscripted = status;
    notifyListeners();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('suscriptedDevice', status);
  }

  void updateScanned(bool status) {
    _scanned = status;
    notifyListeners();
  }

  void updateBleStatus(bool status) {
    _bleStatus = status;
    notifyListeners();
  }

  // _loadSuscriptionState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _isSuscripted = prefs.getBool('suscriptedDevice') ?? true;
  //   notifyListeners();
  // }
}
