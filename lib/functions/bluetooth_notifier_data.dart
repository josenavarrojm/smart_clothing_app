import 'package:flutter/material.dart';

class BlDataNotifier with ChangeNotifier {
  static final BlDataNotifier _instance = BlDataNotifier._internal();
  factory BlDataNotifier() => _instance;
  BlDataNotifier._internal();

  // ignore: non_constant_identifier_names
  String _user_id = '';
  String _deviceName = '';
  String _bpmData = '0';
  String _timeData = '0.0';
  String _temperatureAmbData = '0.0';
  String _temperatureCorporalData = '0.0';
  String _humidityData = '0.0';
  String _accelerometerXData = '0.0';
  String _accelerometerYData = '0.0';
  String _accelerometerZData = '0.0';
  String _dateTimeData = '';
  List<double> _ecgData = [];
  List<double> _ecgDataApp = [];
  List<double> _ecgDataIDApp = [];
  final List<double> _historicoTempCorp = [];
  final List<double> _historicoBPM = [];

  // ignore: non_constant_identifier_names
  String get user_id => _user_id;
  String get deviceName => _deviceName;
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
  List<double> get historicoTempCorp => _historicoTempCorp;
  List<double> get historicoBPM => _historicoBPM;

  void updateUserID(String status) {
    _user_id = status;
    notifyListeners();
  }

  void updateDeviceName(String status) {
    _deviceName = status;
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

  void updateHistoricoTempCorp(double status) {
    _historicoTempCorp.add(status);
    notifyListeners();
  }

  void updateHistoricoBPM(double status) {
    _historicoBPM.add(status);
    notifyListeners();
  }
}
