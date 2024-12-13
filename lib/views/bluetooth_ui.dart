import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartclothingproject/controllers/BLE/bluetooth_services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

String deviceId = '';

class BluetoothUI extends StatefulWidget {
  const BluetoothUI({super.key});

  @override
  _BluetoothUI createState() => _BluetoothUI();
}

class _BluetoothUI extends State<BluetoothUI> {
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
    bleController = BluetoothController(context);
    // Escuchar el estado del escáner
    _subscription = bleController.bleScanner.state.listen((state) {
      if (mounted) {
        setState(() {
          discoveredDevices = state.discoveredDevices
              .where((device) => device.name.contains("ESP32"))
              .toList();
          // .where((device) => device.connectable == Connectable.available)
          scanned = state.scanIsInProgress; // Actualiza el estado del escaneo
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Manager")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await bleController.requestBluetoothActivation();
                  bleController.startScanning([]); // Inicia el escaneo
                  // await Future.delayed(const Duration(seconds: 15));
                  // bleController.stopScanning();
                },
                child: const Text('Escanear Dispositivos'),
              ),
              ElevatedButton(
                onPressed: () async {
                  bleController.subscribeToCharacteristic(
                    deviceId: deviceId,
                    serviceId:
                        Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E"),
                    characteristicId:
                        Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E"),
                  ); // Inicia el escaneo
                  // await Future.delayed(const Duration(seconds: 15));
                  // bleController.stopScanning();
                },
                child: const Text('Suscripción'),
              ),
              ElevatedButton(
                onPressed: () async {
                  bleController.writeCharacteristic(
                      deviceId: deviceId,
                      serviceId:
                          Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E"),
                      characteristicId:
                          Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E"),
                      value: "Hola");
                },
                child: const Text('Enviar data'),
              ),
              scanned
                  ? Column(
                      children: [
                        Text(
                          'Dispositivos encontrados',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(
                          height: 150,
                          child: discoveredDevices.isNotEmpty
                              ? ListView.builder(
                                  itemCount: discoveredDevices.length,
                                  itemBuilder: (context, index) {
                                    final device = discoveredDevices[index];
                                    return ListTile(
                                      title: Text(
                                        device.name.isNotEmpty
                                            ? device.name
                                            : 'Dispositivo sin nombre: ${device.connectable}',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      subtitle: Text(
                                        device.id,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      onTap: () async {
                                        await bleController.connectToDevice(
                                          device.id,
                                        );
                                        setState(() {
                                          deviceId = device.id;
                                          connectedDevice = device;
                                        });
                                      },
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text('No se encontraron dispositivos'),
                                ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'Inicia el escaneo para buscar dispositivos',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
              Text(
                'Temperatura: ${bleController.temperatureAmbData}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Humedad: ${bleController.humidityData}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Accelerometro Z: ${bleController.accelerometerXData}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Accelerometro Y: ${bleController.accelerometerYData}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                'Accelerometro Z: ${bleController.accelerometerZData}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              if (connectedDevice != null) ...[
                const Text('Enviar datos JSON', style: TextStyle(fontSize: 18)),
                TextField(
                  controller: jsonController,
                  decoration: const InputDecoration(
                      labelText: 'Ingrese datos JSON a enviar'),
                ),
                const SizedBox(height: 20),
                const Text('Datos recibidos', style: TextStyle(fontSize: 18)),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(receivedData.isNotEmpty
                      ? receivedData
                      : 'No se han recibido datos aún'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
