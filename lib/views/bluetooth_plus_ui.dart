import 'package:flutter/material.dart';
import 'package:smartclothingproject/controllers/bluetooth_plus_services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'dart:convert';

final blController = BluetoothPlusController();

class BluetoothPlusUI extends StatefulWidget {
  const BluetoothPlusUI({super.key});

  @override
  _BluetoothPlusUI createState() => _BluetoothPlusUI();
}

class _BluetoothPlusUI extends State<BluetoothPlusUI> {
  var devicesActived = 10;
  bool hasBT = false;
  bool pressedSupportedBtn = false;
  bool isSwitched = false;
  bool scanned = false;
  List<ScanResult> scanResults = [];
  BluetoothDevice? connectedDevice;
  final TextEditingController jsonController = TextEditingController();
  String receivedData = '';

  @override
  void initState() {
    super.initState();
    // Escuchar los datos recibidos
    blController.dataStream.listen((data) {
      setState(() {
        receivedData = data; // Actualiza la UI al recibir datos
      });
    });
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
              if (pressedSupportedBtn)
                Card(
                  child: Text(
                    hasBT
                        ? 'El dispositivo soporta Bluetooth'
                        : 'El dispositivo no soporta Bluetooth',
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  hasBT = await blController.isSupported();
                  pressedSupportedBtn = true;
                  setState(() {});
                },
                child: const Text('Comprobar soporte Bluetooth'),
              ),
              Switch(
                activeColor: Colors.blue,
                activeTrackColor: Colors.yellow,
                inactiveTrackColor: Colors.grey,
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                  if (isSwitched) {
                    blController.enableBluetooth();
                  } else {
                    blController.disableBluetooth();
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  scanResults = await blController.scanForDevices();
                  scanned = true;
                  setState(() {});
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
                          height: 300, // Altura específica para el ListView
                          child: scanResults.isNotEmpty
                              ? ListView.builder(
                                  itemCount: scanResults.length,
                                  itemBuilder: (context, index) {
                                    final result = scanResults[index];
                                    return ListTile(
                                      title: Text(
                                        result.device.platformName.isNotEmpty
                                            ? result.device.platformName
                                            : 'Dispositivo sin nombre',
                                      ),
                                      subtitle:
                                          Text(result.device.remoteId.str),
                                      onTap: () async {
                                        // Conectar al dispositivo y guardar la referencia
                                        await blController
                                            .connectToDevice(result.device);
                                        setState(() {
                                          connectedDevice = result.device;
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
                const Text(
                  'Enviar datos JSON',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: jsonController,
                  decoration: const InputDecoration(
                    labelText: 'Ingrese datos JSON a enviar',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (connectedDevice != null) {
                      // Reemplaza "characteristicUuid" con el UUID correcto de la característica
                      // blController.sendJsonData(
                      //     connectedDevice!,
                      //     json.decode(jsonController.text),
                      //     "characteristicUuid");
                    }
                  },
                  child: const Text('Enviar'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Datos recibidos',
                  style: TextStyle(fontSize: 18),
                ),
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
