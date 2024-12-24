import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class BluetoothPlusController extends GetxController {
  // Comprueba si el dispositivo soporta Bluetooth
  Future<bool> isSupported() async {
    bool isSupported = await FlutterBluePlus.isSupported;
    // print(isSupported
    // ? "Bluetooth is supported by this device"
    // : "Bluetooth not supported by this device");
    return isSupported;
  }

  // Controlador de stream para los datos recibidos
  final StreamController<String> _dataStreamController =
      StreamController<String>.broadcast();

  // Getter para el stream de datos
  Stream<String> get dataStream => _dataStreamController.stream;

  // Otros métodos aquí...

  // Configurar notificaciones para recibir datos JSON del dispositivo
  Future<void> configureNotifications(
      BluetoothDevice device, String characteristicUuid) async {
    try {
      // Obtener el servicio y la característica correctos
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() == characteristicUuid) {
            await characteristic.setNotifyValue(true);
            // print("Notificaciones activadas para la característica: $characteristicUuid");

            // Suscribirse a los datos recibidos
            characteristic.lastValueStream.listen((value) {
              String receivedData = utf8.decode(value);
              // Map<String, dynamic> jsonData = json.decode(receivedData);
              // print("Datos recibidos: $jsonData");

              // Emitir datos al stream
              _dataStreamController.add(receivedData);
            });
            return;
          }
        }
      }
    } catch (e) {
      // print("Error al configurar notificaciones: $e");
    }
  }

  @override
  void onClose() {
    // Cierra el controlador de stream cuando no se necesita
    _dataStreamController.close();
    super.onClose();
  }

  // Escucha los cambios de estado de Bluetooth y enciende el adaptador si es necesario (solo Android)
  Future<void> enableBluetooth() async {
    // Suscripción a cambios en el estado del adaptador Bluetooth
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      // print("Estado del Bluetooth: $state");
      if (state == BluetoothAdapterState.on) {
        // print("Bluetooth encendido");
      } else if (state == BluetoothAdapterState.off) {
        // print("Bluetooth apagado");
      }
    });

    // Encender Bluetooth solo en Android
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
      // Espera un poco para asegurarte de que se encienda
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // Detiene el escaneo y apaga el Bluetooth (solo en Android)
  Future<void> disableBluetooth() async {
    if (Platform.isAndroid) {
      await FlutterBluePlus.stopScan();
      // print("Bluetooth apagado");
    }
  }

  // Escanea dispositivos Bluetooth cercanos
  Future<List<ScanResult>> scanForDevices() async {
    await FlutterBluePlus.adapterState
        .where((state) => state == BluetoothAdapterState.on)
        .first;

    List<ScanResult> devices = [];

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    // Escucha los resultados de escaneo
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (var result in results) {
        // print('Escaneando: ${result.device.remoteId}'); // Debugging line
        if (!devices.any(
            (device) => (device.device.remoteId == result.device.remoteId))) {
          if (result.advertisementData.connectable) devices.add(result);
          // print('${result.device.remoteId}: "${result.advertisementData.connectable}" encontrado');
        }
      }
    }, onError: (e) => print('Error de escaneo: $e'));

    // Espera a que el escaneo se complete
    await FlutterBluePlus.isScanning.where((isScanning) => !isScanning).first;

    // Cancela la suscripción para liberar recursos
    await subscription.cancel();

    // print("Cantidad: ${devices.length}");
    // print("Devices: $devices");
    return devices;
  }

  // Agrega este método en tu clase BluetoothController
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      // Escuchar el estado de conexión
      var subscription =
          device.connectionState.listen((BluetoothConnectionState state) {
        // print("Estado de conexión: $state");
        if (state == BluetoothConnectionState.connected) {
          // print("Conectado al dispositivo: ${device.remoteId}");
        } else if (state == BluetoothConnectionState.disconnected) {
          // print("Desconectado del dispositivo: ${device.remoteId}");
          // Aquí puedes manejar reconexiones si lo deseas
        }
      });

      // Conectar al dispositivo
      try {
        await device.connect();
        // print('Conectado al dispositivo: ${device.remoteId}');
      } catch (e) {
        // print('Error al conectar, reintentando...');
        await device.disconnect();
        await Future.delayed(const Duration(seconds: 1));
        await device.connect();
      }

      // Limpiar la suscripción cuando te desconectas
      device.cancelWhenDisconnected(subscription, delayed: true, next: true);

      // Aquí puedes descubrir servicios después de la conexión si es necesario
      // List<BluetoothService> services = await device.discoverServices();
      // Manejar los servicios descubiertos...
    } catch (e) {
      // print("Error al conectar al dispositivo: $e");
    }
  }

  Future<void> writeDataToDevice(BluetoothDevice device, Uuid serviceUuid,
      Uuid characteristicUuid, String data) async {
    try {
      // Obtener el servicio del dispositivo
      BluetoothService service =
          await device.discoverServices().then((services) {
        return services.firstWhere((service) => service.uuid == serviceUuid,
            orElse: () => throw Exception("Servicio no encontrado"));
      });

      // Obtener la característica donde queremos escribir
      BluetoothCharacteristic characteristic = service.characteristics
          .firstWhere(
              (characteristic) => characteristic.uuid == characteristicUuid,
              orElse: () => throw Exception("Característica no encontrada"));

      // Convertir los datos a formato adecuado (en este caso String a List<int>)
      List<int> value = data.codeUnits;

      // Escribir los datos en la característica
      await characteristic.write(value);
      // print("Datos enviados correctamente.");
    } catch (e) {
      // print("Error al enviar los datos: $e");
    }
  }

  // Enviar datos JSON al dispositivo
  // Future<void> sendJsonData(BluetoothDevice device, Map<String, dynamic> data,
  //     String characteristicUuid) async {
  //   try {
  //     // Convertir el mapa de datos a JSON y luego a bytes
  //     String jsonData = json.encode(data);
  //     List<int> dataBytes = utf8.encode(jsonData);

  //     // Obtener el servicio y la característica correctos para enviar los datos
  //     List<BluetoothService> services = await device.discoverServices();
  //     for (BluetoothService service in services) {
  //       for (BluetoothCharacteristic characteristic
  //           in service.characteristics) {
  //         if (characteristic.properties.write) {
  //           await characteristic.write(dataBytes, withoutResponse: true);
  //           // print("Datos enviados: $jsonData");
  //           return;
  //         } else {
  //           // print("La característica no soporta escritura.");
  //         }
  //         if (characteristic.uuid.toString() == characteristicUuid) {
  //           await characteristic.write(dataBytes, withoutResponse: true);
  //           // print("Datos enviados: $jsonData");
  //           return;
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     // print("Error al enviar datos: $e");
  //   }
  // }

  // // Configurar notificaciones para recibir datos JSON del dispositivo
  // Future<void> configureNotifications(
  //     BluetoothDevice device, String characteristicUuid) async {
  //   try {
  //     // Obtener el servicio y la característica correctos
  //     List<BluetoothService> services = await device.discoverServices();
  //     for (BluetoothService service in services) {
  //       for (BluetoothCharacteristic characteristic
  //           in service.characteristics) {
  //         if (characteristic.uuid.toString() == characteristicUuid) {
  //           await characteristic.setNotifyValue(true);
  //           // print(
  //               "Notificaciones activadas para la característica: $characteristicUuid");

  //           // Suscribirse a los datos recibidos
  //           characteristic.value.listen((value) {
  //             String receivedData = utf8.decode(value);
  //             Map<String, dynamic> jsonData = json.decode(receivedData);
  //             // print("Datos recibidos: $jsonData");

  //             // Aquí puedes actualizar la interfaz de usuario o manejar los datos
  //           });
  //           return;
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     // print("Error al configurar notificaciones: $e");
  //   }
  // }
}
