import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'reactive_state.dart';
import 'package:meta/meta.dart';

final flutterReactiveBle = FlutterReactiveBle();

class BluetoothController {
  final BleScanner _bleScanner;
  final BleDeviceConnector _deviceConnector;

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
  Stream<List<int>> subscribeToCharacteristic({
    required String deviceId,
    required Uuid serviceId,
    required Uuid characteristicId,
  }) {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceId,
      characteristicId: characteristicId,
      deviceId: deviceId,
    );

    return flutterReactiveBle.subscribeToCharacteristic(characteristic);
  }

  // Método para enviar datos a una característica
  Future<void> writeCharacteristic({
    required String deviceId,
    required Uuid serviceId,
    required Uuid characteristicId,
    required List<int> value,
  }) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceId,
      characteristicId: characteristicId,
      deviceId: deviceId,
    );

    await flutterReactiveBle.writeCharacteristicWithResponse(
      characteristic,
      value: value,
    );
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

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  late StreamSubscription<ConnectionStateUpdate> _connection;

  Future<void> connect(String deviceId) async {
    _logMessage('Start connecting to $deviceId');
    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) {
        _logMessage(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        _deviceConnectionController.add(update);
      },
      onError: (Object e) =>
          _logMessage('Connecting to device $deviceId resulted in error $e'),
    );
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
    }
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
