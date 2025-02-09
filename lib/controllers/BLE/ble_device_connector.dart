import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smartclothingproject/controllers/BLE/reactive_state.dart';
import 'package:smartclothingproject/functions/ble_connected_state_notifier.dart';
import 'package:smartclothingproject/functions/persistance_data.dart';

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

  final Map<String, StreamSubscription<ConnectionStateUpdate>>
      _activeConnections = {};

  Future<void> connect(
      String deviceId, StreamSubscription<List<int>>? subscription) async {
    await _ble.deinitialize();
    await Future.delayed(
        const Duration(seconds: 1)); // Pequeña espera antes de re-inicializar

    final completer = Completer<void>();

    _logMessage('Start connecting to $deviceId');

    _connection = _ble.connectToDevice(id: deviceId).listen(
      (update) async {
        _logMessage(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        saveDeviceId(deviceId);
        _deviceConnectionController.add(update);
        _activeConnections[deviceId] = _connection;

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
          // await _cancelSubscription(subscription);
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
    if (_activeConnections.containsKey(deviceId)) {
      try {
        // Cancelar la suscripción activa para ese dispositivo
        await _activeConnections[deviceId]!.cancel();
        _activeConnections.remove(deviceId);

        _logMessage('Dispositivo $deviceId desconectado correctamente.');

        // Actualizar estados de conexión
        BleConnectionService().updateConnectionStatus(false);
        BleConnectionService().updateSuscriptionStatus(false);
        BleConnectionService().updateLostConnection(true);

        // Llamar a deinitialize para limpiar el estado BLE (opcional)
        await _ble.deinitialize();

        // Opcional: eliminar el deviceId de la persistencia
        saveDeviceId('');
      } catch (e) {
        _logMessage('Error al desconectar el dispositivo $deviceId: $e');
      }
    } else {
      _logMessage('No existe conexión activa para el dispositivo $deviceId.');
    }
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
