import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartclothingproject/controllers/BLE/bluetooth_services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

final blController = BluetoothController();

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

  @override
  void initState() {
    super.initState();
    requestPermissions();

    // Escuchar el estado del escáner
    _subscription = blController.bleScanner.state.listen((state) {
      if (mounted) {
        setState(() {
          discoveredDevices = state.discoveredDevices
              .where((device) => device.connectable == Connectable.available)
              .toList();
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
    if (await Permission.location.request().isGranted) {
      print("Location permission is granted");
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
    } else {
      print("Location permission is not granted");
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
                  await blController.requestBluetoothActivation();
                  blController.startScanning([]); // Inicia el escaneo
                  // await Future.delayed(const Duration(seconds: 15));
                  // blController.stopScanning();
                },
                child: const Text('Escanear Dispositivos'),
              ),
              scanned
                  ? Column(
                      children: [
                        const Text(
                          'Dispositivos encontrados',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 300,
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
                                      ),
                                      subtitle: Text(device.id),
                                      onTap: () async {
                                        await blController
                                            .connectToDevice(device.id);
                                        setState(() {
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
                  : const Center(
                      child: Text('Inicia el escaneo para buscar dispositivos'),
                    ),
              const SizedBox(height: 20),
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
