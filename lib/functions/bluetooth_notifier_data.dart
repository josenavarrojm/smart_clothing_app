import 'package:flutter/material.dart';

class BlDataNotifier with ChangeNotifier {
  static final BlDataNotifier _instance = BlDataNotifier._internal();
  factory BlDataNotifier() => _instance;
  BlDataNotifier._internal();

  String _temperatureData = '';
  String _humidityData = '';
  String _accelerometerXData = '';
  String _accelerometerYData = '';
  String _accelerometerZData = '';

  String get temperatureData => _temperatureData;
  String get humidityData => _humidityData;
  String get accelerometerXData => _accelerometerXData;
  String get accelerometerYData => _accelerometerYData;
  String get accelerometerZData => _accelerometerZData;

  void updateTemperatureData(String status) {
    _temperatureData = status;
    notifyListeners();
  }

  void updateHumidityData(String status) {
    _humidityData = status;
    notifyListeners();
  }

  void updateAccelerometerXData(String status) {
    _accelerometerXData = status;
    notifyListeners();
  }

  void updateAccelerometerYData(String status) {
    _accelerometerYData = status;
    notifyListeners();
  }

  void updateAccelerometerZData(String status) {
    _accelerometerZData = status;
    notifyListeners();
  }
}
