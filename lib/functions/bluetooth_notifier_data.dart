import 'package:flutter/material.dart';

class BlDataNotifier with ChangeNotifier {
  static final BlDataNotifier _instance = BlDataNotifier._internal();
  factory BlDataNotifier() => _instance;
  BlDataNotifier._internal();

  String _user_id = '';
  String _bpmData = '';
  String _timeData = '';
  String _temperatureAmbData = '';
  String _temperatureCorporalData = '';
  String _humidityData = '';
  String _accelerometerXData = '';
  String _accelerometerYData = '';
  String _accelerometerZData = '';
  String _dateTimeData = '';
  List<double> _ecgData = [];
  List<double> _ecgDataApp = [];
  List<double> _ecgDataIDApp = [];

  String get user_id => _user_id;
  String get bpmData => _bpmData;
  String get timeData => _timeData;
  String get temperatureAmbData => _temperatureAmbData;
  String get temperatureCorporalData => _temperatureCorporalData;
  String get humidityData => _humidityData;
  String get accelerometerXData => _accelerometerXData;
  String get accelerometerYData => _accelerometerYData;
  String get accelerometerZData => _accelerometerZData;
  String get dateTimeData => _dateTimeData;
  List<double> get ecgData => _ecgData;
  List<double> get ecgDataApp => _ecgDataApp;
  List<double> get ecgDataIDApp => _ecgDataIDApp;

  void updateUserID(String status) {
    _user_id = status;
    notifyListeners();
  }

  void updatebpmData(String status) {
    _bpmData = status;
    notifyListeners();
  }

  void updatetimeData(String status) {
    _timeData = status;
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

  void updateECGData(List<double> status) {
    _ecgData = status;
    notifyListeners();
  }

  void updateECGDataApp(List<double> status) {
    _ecgDataApp = status;
    notifyListeners();
  }

  void updateECGDataIDApp(List<double> status) {
    _ecgDataIDApp = status;
    notifyListeners();
  }

  void updateDateTimeData(String status) {
    _dateTimeData = status;
    notifyListeners();
  }
}
