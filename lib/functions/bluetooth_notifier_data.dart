import 'package:flutter/material.dart';

/// BlDataNotifier es un singleton que actúa como proveedor de datos centralizados.
/// Permite la gestión de datos relacionados con biomedicina, como BPM, temperatura, acelerómetro, entre otros.
class BlDataNotifier with ChangeNotifier {
  // Singleton
  static final BlDataNotifier _instance = BlDataNotifier._internal();
  factory BlDataNotifier() => _instance;
  BlDataNotifier._internal();

  // Propiedades privadas
  late String _userID;
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

  // Getters: Proveen acceso de solo lectura a los datos.
  String get userID => _userID;
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
  List<double> get ecgData => List.unmodifiable(_ecgData); // Copia inmutable
  List<double> get ecgDataApp =>
      List.unmodifiable(_ecgDataApp); // Copia inmutable
  List<double> get ecgDataIDApp =>
      List.unmodifiable(_ecgDataIDApp); // Copia inmutable
  List<double> get historicoTempCorp => List.unmodifiable(_historicoTempCorp);
  List<double> get historicoBPM => List.unmodifiable(_historicoBPM);

  // Método genérico para actualizar datos simples
  void updateData<T>(T value, void Function(T) updater) {
    updater(value);
    notifyListeners();
  }

  // Métodos de actualización específicos
  void updateUserID(String value) => updateData(value, (v) => _userID = v);
  void updateDeviceName(String value) =>
      updateData(value, (v) => _deviceName = v);
  void updateBpmData(String value) => updateData(value, (v) => _bpmData = v);
  void updateTimeData(String value) => updateData(value, (v) => _timeData = v);
  void updateTemperatureAmbData(String value) =>
      updateData(value, (v) => _temperatureAmbData = v);
  void updateTemperatureCorporalData(String value) =>
      updateData(value, (v) => _temperatureCorporalData = v);
  void updateHumidityData(String value) =>
      updateData(value, (v) => _humidityData = v);
  void updateAccelerometerXData(String value) =>
      updateData(value, (v) => _accelerometerXData = v);
  void updateAccelerometerYData(String value) =>
      updateData(value, (v) => _accelerometerYData = v);
  void updateAccelerometerZData(String value) =>
      updateData(value, (v) => _accelerometerZData = v);
  void updateDateTimeData(String value) =>
      updateData(value, (v) => _dateTimeData = v);

  // Métodos para listas
  void updateECGData(List<double> value) =>
      updateData(value, (v) => _ecgData = v);
  void updateECGDataApp(List<double> value) =>
      updateData(value, (v) => _ecgDataApp = v);
  void updateECGDataIDApp(List<double> value) =>
      updateData(value, (v) => _ecgDataIDApp = v);

  // Métodos para añadir al histórico
  void addHistoricoTempCorp(double value) {
    _historicoTempCorp.add(value);
    notifyListeners();
  }

  void addHistoricoBPM(double value) {
    _historicoBPM.add(value);
    notifyListeners();
  }
}
