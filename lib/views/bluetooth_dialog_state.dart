import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartclothingproject/controllers/BLE/bluetooth_services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartclothingproject/functions/connected_state_notifier.dart';
import 'package:smartclothingproject/models/user_model.dart';

String deviceId = '';
String deviceName = '';

void showCustomToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.5),
      textColor: Colors.white,
      fontSize: 16.0);
}

class BluetoothDialog extends StatefulWidget {
  final UserModel user;
  const BluetoothDialog({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _BluetoothDialogState createState() => _BluetoothDialogState();
}

class _BluetoothDialogState extends State<BluetoothDialog> {
  bool scanned = false;
  List<DiscoveredDevice> discoveredDevices = [];
  DiscoveredDevice? connectedDevice;
  final TextEditingController jsonController = TextEditingController();
  String receivedData = '';
  StreamSubscription? _subscription;
  late BluetoothController bleController;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    startScanningDevices();
    bleController = BluetoothController(context, widget.user);
    // Escuchar el estado del escáner
    _subscription = bleController.bleScanner.state.listen((state) {
      if (mounted) {
        setState(() {
          if (!ConnectionService().isConnected &&
              !ConnectionService().isSuscripted) {
            discoveredDevices = state.discoveredDevices
                .where((device) => ["Esp", "ESP32", "esp", "Esp32", "ESp32"]
                    .any((keyword) => device.name.contains(keyword)))
                .toList();
            // .where((device) => device.connectable == Connectable.available)
            if (discoveredDevices.isNotEmpty) {
              if (ConnectionService().deviceFound) {
                setConnection();
              }
              // if (ConnectionService().isConnected) {
              //   setSuscription();
              // }
            }
            scanned = state.scanIsInProgress; // Actualiza el estado del escaneo
          } else if (!ConnectionService().isConnected &&
              ConnectionService().isSuscripted) {
            bleController.disconnectFromDevice(deviceId);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancela la suscripción
    super.dispose();
  }

  Future<void> requestPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      print("Bluetooth permission is granted");
      if (await Permission.bluetoothConnect.request().isGranted) {
        print("Bluetooth Connection permission is granted");
      } else {
        print("Bluetooth permission is not granted");
      }
    } else {
      print("Bluetooth permission is not granted");
    }
  }

  Future<void> startScanningDevices() async {
    // Mostrar mensaje de inicio de escaneo
    await Future.delayed(const Duration(seconds: 2));
    await bleController.requestBluetoothActivation();
    bleController.startScanning([]);
  }

  Future<void> setConnection() async {
    if (!ConnectionService().isConnected) {
      setState(() {
        deviceId = discoveredDevices.first.id;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      await bleController.connectToDevice(deviceId);
      scanned = false;
      ConnectionService().updateDeviceStatus(false);
      Fluttertoast.cancel();
      bleController.subscribeToCharacteristic(
        deviceId: deviceId,
        serviceId: Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E"),
        characteristicId: Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E"),
      );
      ConnectionService().updateSuscriptionStatus(true);
      bleController.stopScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        textAlign: TextAlign.center,
        ConnectionService().isSuscripted || ConnectionService().isConnected
            ? 'Dispositivo conectado'
            : scanned
                ? ''
                : 'Buscando Dispositivo',
        style: TextStyle(
            fontSize: scanned ? 0 : 25,
            color: ConnectionService().isConnected
                ? Colors.deepOrangeAccent
                : ConnectionService().isSuscripted
                    ? Colors.green
                    : Colors.blueAccent),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConnectionService().isConnected &&
                      !ConnectionService().isSuscripted
                  ? Center(
                      child: ListTile(
                      title: Text(
                        discoveredDevices.first.name,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ))
                  : ConnectionService().isConnected &&
                          ConnectionService().isSuscripted
                      ? Center(
                          child: Icon(
                            Icons.check_box,
                            color: Theme.of(context).primaryColor,
                            size: 58,
                          ),
                          // child: LoadingAnimationWidget.flickr(
                          //   leftDotColor: Colors.orange,
                          //   rightDotColor: Colors.blueAccent,
                          //   size: 50,
                          // ),
                        )
                      : scanned
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Escaneando Dispositivo',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                ),
                                const Text(
                                  'Estableciendo conexión',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blueAccent),
                                ),
                                SizedBox(
                                  height: 150,
                                  child: Center(
                                    child:
                                        LoadingAnimationWidget.fourRotatingDots(
                                      color: Colors.blueAccent,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: LoadingAnimationWidget.threeArchedCircle(
                                color: Colors.blueAccent,
                                size: 50,
                              ),
                            ),
              if (discoveredDevices.isNotEmpty) ...[
                if (ConnectionService().isConnected)
                  const Text('Conexión exitosa!',
                      style: TextStyle(fontSize: 12))
              ],
            ],
          ),
        ),
      ),
      actions: [
        ConnectionService().isSuscripted
            ? TextButton(
                onPressed: () {
                  if (ConnectionService().isSuscripted) {
                    Navigator.pop(context);
                    bleController.stopScanning();
                  }
                },
                child: const Text(
                  'Cerrar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 18),
                ),
              )
            : (ConnectionService().lostConnection &&
                    ConnectionService().isSuscripted)
                ? TextButton(
                    onPressed: () {
                      if (ConnectionService().isSuscripted) {
                        bleController.stopScanning();
                      }
                    },
                    child: const Text(
                      'Reconectar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 18),
                    ),
                  )
                : const Text('')
      ],
    );
  }
}
