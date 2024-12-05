import 'package:flutter/material.dart';

class BlDataNotifier with ChangeNotifier {
  static final BlDataNotifier _instance = BlDataNotifier._internal();
  factory BlDataNotifier() => _instance;
  BlDataNotifier._internal();

  String _bpmData = '';
  String _temperatureAmbData = '';
  String _temperatureCorporalData = '';
  String _humidityData = '';
  String _accelerometerXData = '';
  String _accelerometerYData = '';
  String _accelerometerZData = '';

  String get bpmData => _bpmData;
  String get temperatureAmbData => _temperatureAmbData;
  String get temperatureCorporalData => _temperatureCorporalData;
  String get humidityData => _humidityData;
  String get accelerometerXData => _accelerometerXData;
  String get accelerometerYData => _accelerometerYData;
  String get accelerometerZData => _accelerometerZData;

  void updatebpmData(String status) {
    _bpmData = status;
    notifyListeners();
  }

  void updateTemperatureAmbData(String status) {
    _temperatureAmbData = status;
    notifyListeners();
  }

  void updateTemperatureCorporalData(String status) {
    _temperatureCorporalData = status;
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
