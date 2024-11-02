import 'package:flutter/material.dart';
import 'package:ladys_app/controllers/bluetooth_services.dart';

final blController = BluetoothController();

class BlueetoothUI extends StatefulWidget {
  const BlueetoothUI({super.key});

  @override
  _BluetoothUI createState() => _BluetoothUI();
}

class _BluetoothUI extends State<BlueetoothUI> {
  var devicesActived = 10;
  bool hasBT = false;
  bool pressedSupportedBtn = false;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(seconds: 200),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                if (pressedSupportedBtn)
                  hasBT
                      ? const Card(
                          child: Text('el dispositivo soporta Bluetooth'))
                      : const Card(
                          child: Text('el dispositivo no soporta Bluetooth')),
                ElevatedButton(
                    onPressed: () async {
                      hasBT = await blController.isSupported();
                      pressedSupportedBtn = true;
                      setState(() {});
                    },
                    child: const Text('Comprobar soporte Bluetooth')),
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
                      hasBT = await blController.isSupported();
                    },
                    child: const Text('Encender Bluetooth')),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Apagara Bluetooth')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        devicesActived++;
                      });
                    },
                    child: const Text('Escanear Dispositivos')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        devicesActived--;
                      });
                    },
                    child: const Text('Encender Bluetooth')),
              ],
            )));
  }
}
