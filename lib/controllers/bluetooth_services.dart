import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'dart:io';

class BluetoothController extends GetxController {
  Future<bool> isSupported() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return false;
    } else {
      print("Bluetooth is supported by this device");
      return true;
    }
  }

  Future<void> enableBluetooth() async {
    // Suscríbete para escuchar cambios en el estado del adaptador de Bluetooth
    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print("Estado del Bluetooth: $state");
      if (state == BluetoothAdapterState.on) {
        print("Bluetooth encendido");
        // Aquí puedes agregar el código para escanear dispositivos, conectar, etc.
      } else {
        print("Bluetooth apagado");
        // Maneja el caso de que Bluetooth esté apagado, como mostrar un mensaje
      }
    });

    // Intenta encender el Bluetooth si estás en Android
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // Cancela la suscripción para evitar escuchas duplicadas
    await subscription.cancel();
  }

  Future<void> disableBluetooth() async {
    if (Platform.isAndroid) {
      await FlutterBluePlus.stopScan();
      print("Bluetooth apagado");
    }
  }
}
