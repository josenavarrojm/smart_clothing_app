import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/connected_state_notifier.dart';
import 'package:smartclothingproject/views/bluetooth_dialog_state.dart';
import 'reactive_state.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

final flutterReactiveBle = FlutterReactiveBle();

class BluetoothController {
  final BleScanner _bleScanner;
  final BleDeviceConnector _deviceConnector;
  String accelerometerXData = '';
  String accelerometerYData = '';
  String accelerometerZData = '';
  String temperatureData = '';
  String humidityData = '';

  BluetoothController()
      : _bleScanner = BleScanner(
          ble: flutterReactiveBle,
          logMessage: (message) {
            print(message);
          },
        ),
        _deviceConnector = BleDeviceConnector(
          ble: flutterReactiveBle,
          logMessage: (message) {
            print(message);
          },
        );

  BleScanner get bleScanner => _bleScanner;

  Future<void> requestBluetoothActivation() async {
    var bluetoothState = await FlutterBluePlus.adapterState.first;

    if (bluetoothState == BluetoothAdapterState.off) {
      FlutterBluePlus.turnOn();
    } else {
      print("Bluetooth is enabled, starting discovery.");
    }
  }

  void startScanning(List<Uuid> serviceIds) {
    _bleScanner.startScan(serviceIds);
  }

  Future<void> stopScanning() async {
    await _bleScanner.stopScan();
  }

  Future<void> connectToDevice(String deviceId) async {
    await _deviceConnector.connect(deviceId);
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
    final subscription =
        flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
      (data) async {
        if (data.isNotEmpty && !dataNoEmpty) {
          dataNoEmpty = true;
          ConnectionService().updateSuscriptionStatus(true);
        }
        await Future.delayed(const Duration(milliseconds: 800));
        Fluttertoast.cancel();
        // Convertir el fragmento de datos recibido en texto
        final decodedFragment = String.fromCharCodes(data);
        print(decodedFragment);

        // print("Fragmento decodificado: $decodedFragment");

        // Verificar si el fragmento contiene la palabra 'temperature'
        if (decodedFragment.contains('temperature')) {
          // Separar la cadena por el delimitador ":"
          if (!ConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String temperatureValue =
                parts[1].trim(); // .trim() elimina espacios extra
            temperatureData = temperatureValue;
            BlDataNotifier().updateTemperatureData(temperatureValue);

            print("Temperatura: $temperatureData");
          }
        } else if ((decodedFragment.contains('humidity'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String humidityValue =
                parts[1].trim(); // .trim() elimina espacios extra
            humidityData = humidityValue;
            BlDataNotifier().updateHumidityData(humidityValue);
            print("Humedad: $humidityData");
          }
        } else if ((decodedFragment.contains('accelx'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelXValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerXData = accelXValue;
            BlDataNotifier().updateAccelerometerXData(accelXValue);

            print("Ángulo X: $accelerometerXData");
          }
        } else if ((decodedFragment.contains('accely'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelYValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerYData = accelYValue;
            BlDataNotifier().updateAccelerometerYData(accelerometerYData);

            print(" BlDataNotifier(): ${BlDataNotifier().accelerometerYData}");
          }
        } else if ((decodedFragment.contains('accelz'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelZValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerZData =
                accelZValue; // Asignamos el valor a la variable temperatureData
            BlDataNotifier().updateAccelerometerZData(accelerometerZData);

            print("Ángulo Z: ${BlDataNotifier().accelerometerZData}");
          }
        }
        //  else if ((decodedFragment.contains('accelz'))) {
        //   // Separar la cadena por el delimitador ":"
        //   var parts = decodedFragment.split(':');

        //   // Asegurarnos de que hay al menos dos partes (la variable y el valor)
        //   if (parts.length > 1) {
        //     // Extraer el valor de temperatura y limpiarlo
        //     String accelZValue =
        //         parts[1].trim(); // .trim() elimina espacios extra
        //     accelerometerZData =
        //         accelZValue; // Asignamos el valor a la variable temperatureData
        //     BlDataNotifier().updateAccelerometerZData(accelerometerZData);

        //     print("Ángulo Z: ${BlDataNotifier().accelerometerZData}");
        //   }
        // }
      },
      onError: (error) {
        print("Error de suscripción: $error");
      },
    );

    return subscription; // Retorna la suscripción para poder cancelarla después
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
          ConnectionService().updateDeviceStatus(true);
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

  Future<void> connect(String deviceId) async {
    final completer = Completer<void>();

    _logMessage('Start connecting to $deviceId');

    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) {
        _logMessage(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        _deviceConnectionController.add(update);

        if (update.connectionState == DeviceConnectionState.connected) {
          ConnectionService().updateConnectionStatus(true);
          ConnectionService().updateLostConnection(false);
          connected = true;
          completer.complete(); // Completa la conexión cuando está conectado.
        }
        if (update.connectionState == DeviceConnectionState.disconnected &&
            connected) {
          connected = false;
          ConnectionService().updateConnectionStatus(false);
          ConnectionService().updateSuscriptionStatus(false);
          ConnectionService().updateLostConnection(true);
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
      ConnectionService().updateSuscriptionStatus(false);
      ConnectionService().updateConnectionStatus(false);
    }
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
