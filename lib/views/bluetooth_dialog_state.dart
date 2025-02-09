import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartclothingproject/controllers/BLE/bluetooth_services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartclothingproject/functions/ble_connected_state_notifier.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
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
  List<DiscoveredDevice> discoveredDevices = [];
  DiscoveredDevice? connectedDevice;
  final TextEditingController jsonController = TextEditingController();
  String receivedData = '';
  StreamSubscription? _subscription;
  late BluetoothController bleController;

  void checkBleState() async {
    var bluetoothState = await FlutterBluePlus.adapterState.first;
    if (bluetoothState == BluetoothAdapterState.off) {
      BleConnectionService().updateBleStatus(true);
    } else {
      BleConnectionService().updateBleStatus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
      ));
    });

    checkBleState();

    requestPermissions();
    startScanningDevices();
    setState(() {});
    bleController = BluetoothController(context, widget.user);
    // Escuchar el estado del escáner
    _subscription = bleController.bleScanner.state.listen((state) {
      if (mounted) {
        setState(() {
          if (!BleConnectionService().isConnected &&
              !BleConnectionService().isSuscripted) {
            discoveredDevices = state.discoveredDevices
                .where((device) => ["Esp", "ESP32", "esp", "Esp32", "ESp32"]
                    .any((keyword) => device.name.contains(keyword)))
                .toList();
            // .where((device) => device.connectable == Connectable.available)
            if (discoveredDevices.isNotEmpty) {
              BleConnectionService().updateDeviceStatus(true);
              if (BleConnectionService().deviceFound) {
                setConnection();
              }
              // if (BleConnectionService().isConnected) {
              //   setSuscription();
              // }
            }
            BleConnectionService().updateScanned(
                state.scanIsInProgress); // Actualiza el estado del escaneo
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
    if (!BleConnectionService().bleStatus) {
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
  }

  Future<void> startScanningDevices() async {
    // Mostrar mensaje de inicio de escaneo
    await Future.delayed(const Duration(seconds: 2));
    await bleController.requestBluetoothActivation();
    bleController.startScanning([]);
  }

  Future<void> setConnection() async {
    if (!BleConnectionService().isConnected) {
      setState(() {
        deviceId = discoveredDevices.first.id;
        BlDataNotifier().updateDeviceName(discoveredDevices.first.name);
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      await bleController.connectToDevice(deviceId);
      BleConnectionService().updateScanned(false);
      BleConnectionService().updateDeviceStatus(false);
      Fluttertoast.cancel();
      bleController.subscribeToCharacteristic(
        deviceId: deviceId,
        serviceId: Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E"),
        characteristicId: Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E"),
      );
      BleConnectionService().updateSuscriptionStatus(true);
      bleController.stopScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    });

    return Scaffold(
      floatingActionButton: !BleConnectionService().isConnected
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const CircleBorder(),
              child: Icon(
                Icons.arrow_downward_rounded,
                color: Theme.of(context).colorScheme.tertiary,
                size: 45,
              ),
            ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!BleConnectionService().bleStatus &&
                !BleConnectionService().deviceFound &&
                !BleConnectionService().scanned &&
                !BleConnectionService().isConnected &&
                !BleConnectionService().isSuscripted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    child: Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 70,
                      ),
                    ),
                  ),
                  Text(
                    'Encendiendo Bluetooth...',
                    style: GoogleFonts.wixMadeforText(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ],
              )
            else if (BleConnectionService().bleStatus &&
                !BleConnectionService().deviceFound &&
                BleConnectionService().scanned &&
                !BleConnectionService().isConnected &&
                !BleConnectionService().isSuscripted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    child: Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 70,
                      ),
                    ),
                  ),
                  Text(
                    'Buscando Dispositivo',
                    style: GoogleFonts.wixMadeforText(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ],
              )
            else if (BleConnectionService().bleStatus &&
                BleConnectionService().deviceFound &&
                !BleConnectionService().isConnected &&
                !BleConnectionService().isSuscripted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    child: Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 70,
                      ),
                    ),
                  ),
                  Text(
                    'Dispositivo Encontrado',
                    style: GoogleFonts.wixMadeforText(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  Text(
                    'Estableciendo conexión con "${BlDataNotifier().deviceName}"',
                    style: GoogleFonts.wixMadeforText(
                        fontSize: 18,
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.9)),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ],
              )
            else if (!BleConnectionService().scanned &&
                BleConnectionService().bleStatus &&
                !BleConnectionService().deviceFound &&
                BleConnectionService().isConnected &&
                BleConnectionService().isSuscripted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                    child: Center(
                      child: Icon(
                        Icons.bluetooth_connected_rounded,
                        color: Colors.green,
                        size: 50,
                      ),
                    ),
                  ),
                  Text(
                    'Dispositivo Conectado',
                    style: GoogleFonts.wixMadeforText(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  Text(
                    BlDataNotifier().deviceName,
                    style: GoogleFonts.wixMadeforText(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
