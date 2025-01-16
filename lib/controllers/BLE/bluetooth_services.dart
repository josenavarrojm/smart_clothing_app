import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/ble_connected_state_notifier.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/models/local_notifications_service.dart';
import 'package:smartclothingproject/models/user_model.dart';
import 'package:smartclothingproject/views/bluetooth_dialog_state.dart';
import 'reactive_state.dart';
import 'dart:convert';

final flutterReactiveBle = FlutterReactiveBle();

class BluetoothController {
  late final String userid;
  final UserModel user;
  final MongoService mongoService;
  final BleScanner _bleScanner;
  final BleDeviceConnector _deviceConnector;
  int bpmData = 0;
  int timeData = 0;
  double temperatureAmbData = 0.0;
  double temperatureCorporalData = 0.0;
  double humidityData = 0.0;
  double accelerometerXData = 0.0;
  double accelerometerYData = 0.0;
  double accelerometerZData = 0.0;
  List<double> ecgDataReceived = [];
  List<double> ecgDataIDReceived = [];
  String readData = '';
  List<Map<String, dynamic>> dataMongoDB = [];

  StreamSubscription<List<int>>? subscription;

  Map<String, dynamic> dataReceived = {
    "_id": ObjectId(),
    "bpm": 0,
    "tempAmb": 0,
    "tempCorp": 0,
    "hum": 0,
    "acelX": 0,
    "acelY": 0,
    "acelZ": 0,
    "time": 0,
    "ecg": <double>[],
    "created_at": "",
  };

  List<Map<String, dynamic>> parseEcgData(List<String> ecgDataReceived) {
    List<Map<String, dynamic>> parsedData = [];

    for (String data in ecgDataReceived) {
      // Match para extraer índice y valores
      final regex = RegExp(r"(\d+)\sECG:\s\[(.+)\]");
      final match = regex.firstMatch(data);

      if (match != null) {
        int index = int.parse(match.group(1)!);
        List<double> values = match
            .group(2)!
            .split(', ')
            .map((value) => double.parse(value))
            .toList();

        parsedData.add({"index": index, "values": values});
      }
    }

    return parsedData;
  }

  BluetoothController(BuildContext context, this.user)
      : mongoService = Provider.of<MongoService>(context, listen: false),
        _bleScanner = BleScanner(
          ble: flutterReactiveBle,
          logMessage: (message) {
            // print(message
          },
        ),
        _deviceConnector = BleDeviceConnector(
          ble: flutterReactiveBle,
          logMessage: (message) {
            // print(message);
          },
        ) {
    // Inicialización de userid después de que se asigna `user`
    userid = user.user_id;
    dataReceived["user_id"] = userid;
  }

  BleScanner get bleScanner => _bleScanner;

  Future<void> requestBluetoothActivation() async {
    var bluetoothState = await FlutterBluePlus.adapterState.first;
    if (bluetoothState == BluetoothAdapterState.on) {
      BleConnectionService().updateBleStatus(true);
    }

    if (bluetoothState == BluetoothAdapterState.off) {
      await FlutterBluePlus.turnOn();
      BleConnectionService().updateBleStatus(true);
    }
  }

  void startScanning(List<Uuid> serviceIds) {
    BleConnectionService().updateScanned(true);
    _bleScanner.startScan(serviceIds);
  }

  Future<void> stopScanning() async {
    await _bleScanner.stopScan();
  }

  Future<void> connectToDevice(String deviceId) async {
    await _deviceConnector.connect(deviceId, subscription);
  }

  Future<void> disconnectFromDevice(String deviceId) async {
    await _deviceConnector.disconnect(deviceId);
  }

  // Método de suscripción a una característica
  // StringBuffer _receivedDataBuffer = StringBuffer();

  StreamSubscription<List<int>>? subscribeToCharacteristic({
    required String deviceId,
    required Uuid serviceId,
    required Uuid characteristicId,
  }) {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceId,
      characteristicId: characteristicId,
      deviceId: deviceId,
    );

    // Suscripción al flujo de datos de la característica
    bool dataNoEmpty = false;
    subscription?.cancel();
    subscription =
        flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
      (data) async {
        if (data.isNotEmpty && !dataNoEmpty) {
          dataNoEmpty = true;
          BleConnectionService().updateSuscriptionStatus(true);
        }
        Fluttertoast.cancel();
        // Convertir el fragmento de datos recibido en texto
        final decodedFragment = String.fromCharCodes(data);
        // print(decodedFragment);
        // // Verificar si el fragmento contiene la palabra 'temperature'
        if (decodedFragment.contains('time')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String valueReceived =
                parts[1].trim(); // .trim() elimina espacios extra
            timeData = double.parse(valueReceived).toInt();

            dataReceived["time"] = timeData;
          }
        } else if (decodedFragment.contains('BPM')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String valueReceived =
                parts[1].trim(); // .trim() elimina espacios extra
            bpmData = double.parse(valueReceived).toInt();

            dataReceived["bpm"] = bpmData;
            // print("bpm: ${BlDataNotifier().bpmData}");
          }
        } else if (decodedFragment.contains('tempAmb')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String valueReceived =
                parts[1].trim(); // .trim() elimina espacios extra
            temperatureAmbData = double.parse(valueReceived);

            dataReceived["tempAmb"] = temperatureAmbData;
            // print("Temperatura Ambiente: ${BlDataNotifier().temperatureAmbData}");
          }
        } else if (decodedFragment.contains('tempCorp')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            if (parts[1].trim() == 'None') {
            } else {
              // Extraer el valor de temperatura y limpiarlo
              String valueReceived =
                  parts[1].trim(); // .trim() elimina espacios extra
              temperatureCorporalData = double.parse(valueReceived);

              dataReceived["tempCorp"] = temperatureCorporalData;
              // print("Temperatura corporal: ${BlDataNotifier().temperatureCorporalData}");
            }
          }
        } else if (decodedFragment.contains('hum')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String valueReceived =
                parts[1].trim(); // .trim() elimina espacios extra
            humidityData = double.parse(valueReceived);

            dataReceived["hum"] = humidityData;
            // print("Humedad: ${BlDataNotifier().humidityData}");
          }
        } else if ((decodedFragment.contains('acelX1'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelXValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerXData = double.parse(accelXValue);

            dataReceived["acelX"] = accelerometerXData;
            // print("Ángulo X1: ${BlDataNotifier().accelerometerXData}");
          }
        } else if ((decodedFragment.contains('acelX2'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelYValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerYData = double.parse(accelYValue);

            dataReceived["acelY"] = accelerometerYData;
            // print("Ángulo X2: ${BlDataNotifier().accelerometerYData}");
          }
        } else if ((decodedFragment.contains('acelZ'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelZValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerZData = double.parse(accelZValue);

            dataReceived["acelZ"] = accelerometerZData;
            // print("Ángulo Z: ${BlDataNotifier().accelerometerZData}");
          }
        } else if (decodedFragment.contains('ECG')) {
          // Limitar la lista a 2500 datos
          if (ecgDataIDReceived.length >= 2500) {
            ecgDataIDReceived.removeRange(0, ecgDataIDReceived.length - 2500);
          } else if (BlDataNotifier().ecgData.length < 2500) {
            if (decodedFragment.contains(':')) {
              var parts = decodedFragment.split(':');

              if (parts.length > 1) {
                // Asegúrate de que parts[0] tiene datos y es diferente al último leído
                var prefix = parts[0].split(' ').first;
                if (!ecgDataIDReceived.contains(double.parse(prefix))) {
                  ecgDataIDReceived.add(double.parse(prefix));
                  // Validar si hay datos dentro de corchetes
                  final match = RegExp(r'\[(.+)\]').firstMatch(parts[1]);
                  if (match != null) {
                    String cleanData = match
                        .group(1)!; // Extraer datos dentro de los corchetes
                    try {
                      List<double> values = cleanData
                          .split(",") // Divide los valores por comas
                          .map((value) =>
                              double.parse(value.trim())) // Convierte a double
                          .toList();

                      // Agregar valores a la lista y notificar
                      ecgDataReceived.addAll(values);
                      BlDataNotifier().updateECGData(ecgDataReceived);
                      BlDataNotifier().updateECGDataIDApp(ecgDataIDReceived);
                    } catch (e) {
                      print("Error al parsear los datos: $e");
                    }
                  }
                }
              }
            } else {
              print("Fragmento inválido: $decodedFragment");
            }
          }
        } else if ((decodedFragment.contains('Send'))) {
          var parts = decodedFragment.split(':');
          if (readData != parts[0]) {
            readData = parts[0];
            dataReceived["_id"] = ObjectId();
            dataReceived["ecg"] = BlDataNotifier().ecgData;
            await initializeDateFormatting('es_ES', null);
            Intl.defaultLocale = 'es_ES';
            dataReceived["created_at"] =
                DateFormat('EEE, MMM d, yyyy - hh:mm a').format(DateTime.now());
            if (BlDataNotifier().ecgData.isNotEmpty) {
              try {
                await mongoService.connect();
                await mongoService.insertDocument(dataReceived, "data");

                dataMongoDB = await mongoService.getDocuments("data");
                BlDataNotifier()
                    .updatebpmData(dataMongoDB.last["bpm"].toString());
                BlDataNotifier().updateTemperatureAmbData(
                    dataMongoDB.last["tempAmb"].toString());
                BlDataNotifier().updateTemperatureCorporalData(
                    dataMongoDB.last["tempCorp"].toString());
                BlDataNotifier()
                    .updateHumidityData(dataMongoDB.last["hum"].toString());
                BlDataNotifier().updateAccelerometerXData(
                    dataMongoDB.last["acelX"].toString());
                BlDataNotifier().updateAccelerometerYData(
                    dataMongoDB.last["acelY"].toString());
                BlDataNotifier().updateAccelerometerZData(
                    dataMongoDB.last["acelZ"].toString());
                BlDataNotifier()
                    .updatetimeData(dataMongoDB.last["time"].toString());
                BlDataNotifier()
                    .updateDateTimeData(dataMongoDB.last["created_at"]);
                readData = '';
                BlDataNotifier().updateHistoricoTempCorp(
                    dataMongoDB.last["tempCorp"].toDouble());
                BlDataNotifier()
                    .updateHistoricoBPM(dataMongoDB.last["bpm"].toDouble());

                // Convierte "ecg" en List<double>
                final ecgData = (dataMongoDB.last["ecg"] as List<dynamic>)
                    .map((value) => value is double
                        ? value
                        : double.tryParse(value.toString()) ?? 0.0)
                    .toList();

                BlDataNotifier().updateECGDataApp(ecgData);

                // Activar alertas
                activateTemperatureCorporalAlert();
                activateBPMAlert();
                activatePositionAlert();

                await mongoService.disconnect();
              } catch (e) {
                print("Error al insertar documento: $e");
              }
            }
            ecgDataIDReceived.clear();
            ecgDataReceived.clear();
          }
        }
      },
      onError: (error) {
        print("Error de suscripción: $error");
      },
    );

    return subscription; // Retorna la suscripción para poder cancelarla después
  }

  void activateTemperatureCorporalAlert() async {
    final double tempCorpMonitor =
        double.tryParse(BlDataNotifier().temperatureCorporalData)!;

    if (tempCorpMonitor > 37.5) {
      await LocalNotificationService.showNotification(
        id: Random().nextInt(100000),
        title: 'Alerta de temperatura corporal alta',
        body:
            'Tu temperatura corporal es alta (${tempCorpMonitor.toStringAsFixed(1)}°C). Esto podría ser un signo de fiebre. Considera consultar a un médico si persiste.',
      );
    } else if (tempCorpMonitor < 35.0) {
      await LocalNotificationService.showNotification(
        id: Random().nextInt(100000),
        title: 'Alerta de temperatura corporal baja',
        body:
            'Tu temperatura corporal es baja (${tempCorpMonitor.toStringAsFixed(1)}°C). Esto podría ser un signo de hipotermia. Busca abrigo y atención médica si es necesario.',
      );
    } else {
      // No mostrar notificaciones si la temperatura está dentro del rango normal.
    }
  }

  void activateBPMAlert() async {
    final double bpmMonitor = double.tryParse(BlDataNotifier().bpmData)!;

    if (bpmMonitor > 100.0) {
      await LocalNotificationService.showNotification(
        id: Random().nextInt(100000),
        title: 'Alerta de ritmo cardíaco alto',
        body:
            'Su ritmo cardíaco es alto (${bpmMonitor.toStringAsFixed(1)} BPM). Esto podría ser un signo de taquicardia. Consulte a un médico si persiste.',
      );
    } else if (bpmMonitor < 60.0) {
      await LocalNotificationService.showNotification(
        id: Random().nextInt(100000),
        title: 'Alerta de ritmo cardíaco bajo',
        body:
            'Su ritmo cardíaco es bajo (${bpmMonitor.toStringAsFixed(1)} BPM). Esto podría ser un signo de bradicardia. Consulte a un médico si persiste.',
      );
    } else {
      // No mostrar notificaciones si el BPM está dentro del rango normal.
    }
  }

  void activatePositionAlert() async {
    final double positionMonitor =
        double.tryParse(BlDataNotifier().accelerometerXData)!;

    if (positionMonitor <= 45.0 && positionMonitor >= 0.0) {
      // No mostrar notificaciones si el BPM está dentro del rango normal.
    } else {
      await LocalNotificationService.showNotification(
        id: Random().nextInt(100000),
        title: 'Alerta de postura incorrecta',
        body: 'Corrija su postura, su posición actual no es la adecuada.',
      );
    }
  }

  // Método para enviar datos a una característica
  Future<void> writeCharacteristic({
    required String deviceId,
    required Uuid serviceId,
    required Uuid characteristicId,
    required String value, // Cambié el tipo de `value` a String
  }) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceId,
      characteristicId: characteristicId,
      deviceId: deviceId,
    );

    // Convierte el texto en una lista de bytes (List<int>)
    List<int> valueBytes = utf8.encode(value);

    // Escribe el valor en la característica
    await flutterReactiveBle.writeCharacteristicWithResponse(
      characteristic,
      value: valueBytes,
    );

    print("Texto enviado: $value");
  }

  Future<void> dispose() async {
    await stopScanning();
    await _deviceConnector.dispose();
    await _bleScanner.dispose();
  }
}

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner({
    required FlutterReactiveBle ble,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController<BleScannerState>.broadcast();

  final List<DiscoveredDevice> _devices = [];
  StreamSubscription<DiscoveredDevice>? _subscription;

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  void startScan(List<Uuid> serviceIds) {
    _logMessage('Start BLE discovery');
    _devices.clear();
    _subscription?.cancel();
    _subscription = _ble.scanForDevices(withServices: serviceIds).listen(
      (device) {
        final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          _devices[knownDeviceIndex] = device;
        } else {
          _devices.add(device);
        }
        _pushState();
      },
      onError: (Object e) => _logMessage('Device scan failed with error: $e'),
    );
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Stop BLE discovery');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}

class BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  bool? connectionStateDevice;
  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  late StreamSubscription<ConnectionStateUpdate> _connection;
  bool connected = false;

  Future<void> connect(
      String deviceId, StreamSubscription<List<int>>? subscription) async {
    final completer = Completer<void>();

    _logMessage('Start connecting to $deviceId');

    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) async {
        _logMessage(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        _deviceConnectionController.add(update);

        if (update.connectionState == DeviceConnectionState.connected) {
          try {
            // Negociar el MTU después de establecer la conexión
            final mtu = await _ble.requestMtu(deviceId: deviceId, mtu: 247);
            _logMessage('MTU negociado: $mtu');
          } catch (e) {
            _logMessage('Error al negociar el MTU: $e');
          }

          BleConnectionService().updateConnectionStatus(true);
          BleConnectionService().updateLostConnection(false);
          connected = true;
          completer.complete(); // Completa la conexión cuando está conectado.
        }

        if (update.connectionState == DeviceConnectionState.disconnected &&
            connected) {
          connected = false;
          BleConnectionService().updateConnectionStatus(false);
          BleConnectionService().updateSuscriptionStatus(false);
          BleConnectionService().updateLostConnection(true);
          await _cancelSubscription(subscription);
        }
      },
      onError: (Object e) {
        _logMessage('Connecting to device $deviceId resulted in error $e');
        if (!completer.isCompleted) {
          completer.completeError(e); // Completa con error si ocurre.
        }
      },
    );

    // Espera a que se complete la conexión o ocurra un error.
    await completer.future;
  }

  Future<void> _cancelSubscription(
      StreamSubscription<List<int>>? subscription) async {
    if (subscription != null) {
      await subscription.cancel();
      subscription = null;
      _logMessage('Suscripción cancelada');
    }
  }

  Future<void> disconnect(String deviceId) async {
    try {
      _logMessage('Disconnecting from device: $deviceId');
      await _connection.cancel();
    } on Exception catch (e, _) {
      _logMessage("Error disconnecting from device: $e");
    } finally {
      _deviceConnectionController.add(
        ConnectionStateUpdate(
          deviceId: deviceId,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        ),
      );
      connected = false;
      if (connected) showCustomToast('Dispositivo desconectado');
      BleConnectionService().updateSuscriptionStatus(false);
      BleConnectionService().updateConnectionStatus(false);
    }
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
