// connection_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionService with ChangeNotifier {
  static final ConnectionService _instance = ConnectionService._internal();
  factory ConnectionService() => _instance;
  ConnectionService._internal();
  //  {
  //   _loadSuscriptionState();
  // }

  bool _isConnected = false;
  bool _isSuscripted = false;

  bool get isConnected => _isConnected;

  void updateConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }

  bool get isSuscripted => _isSuscripted;

  void updateSuscriptionStatus(bool status) {
    _isSuscripted = status;
    notifyListeners();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('suscriptedDevice', status);
  }

  // _loadSuscriptionState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _isSuscripted = prefs.getBool('suscriptedDevice') ?? true;
  //   notifyListeners();
  // }
}
