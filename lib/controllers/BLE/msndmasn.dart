// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bluetooth Low Energy',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   FlutterReactiveBle _ble = FlutterReactiveBle();
//   DiscoveredDevice? _device;
//   Stream<List<int>>? _notificationStream;

//   // Variables para almacenar los datos
//   String accelerometerData = '';
//   String temperatureData = '';
//   String humidityData = '';

//   @override
//   void initState() {
//     super.initState();
//     _scanForDevices();
//   }

//   // Escanear dispositivos BLE cercanos
//   void _scanForDevices() {
//     _ble.scanForDevices(withServices: []).listen((scanResult) {
//       if (scanResult.name == 'ESP32-Sensor') {
//         setState(() {
//           _device = scanResult;
//         });
//         _connectToDevice(scanResult);
//       }
//     });
//   }

//   // Conectar al dispositivo BLE
//   void _connectToDevice(DiscoveredDevice device) async {
//     await _ble.connectToDevice(id: device.id);
//     _discoverServices(device);
//   }

//   // Descubrir los servicios y características del dispositivo
//   void _discoverServices(DiscoveredDevice device) async {
//     List<DiscoveredService> services = await _ble.discoverServices(device.id);

//     // Buscar servicio y característica de escritura para enviar datos
//     services.forEach((service) {
//       if (service.uuid.toString() == '6E400001-B5A3-F393-E0A9-E50E24DCCA9E') {
//         final characteristic = service.characteristics
//             .firstWhere((char) =>
//                 char.uuid.toString() == '6E400003-B5A3-F393-E0A9-E50E24DCCA9E');
//         _enableNotifications(characteristic);
//       }
//     });
//   }

//   // Habilitar notificaciones para recibir datos
//   void _enableNotifications(DiscoveredCharacteristic characteristic) {
//     _notificationStream = _ble.subscribeToCharacteristic(characteristic);
//     _notificationStream!.listen((value) {
//       String receivedData = utf8.decode(value);
//       _parseReceivedData(receivedData);
//     });
//   }

//   // Parsear los datos recibidos
//   void _parseReceivedData(String data) {
//     setState(() {
//       var jsonData = json.decode(data);
//       accelerometerData = jsonData['accelerometer'].toString();
//       temperatureData = jsonData['temperature'].toString();
//       humidityData = jsonData['humidity'].toString();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _device?.id != null ? _ble.disconnectDevice(id: _device!.id) : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Low Energy'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Accelerometer Data: $accelerometerData'),
//             SizedBox(height: 10),
//             Text('Temperature Data: $temperatureData'),
//             SizedBox(height: 10),
//             Text('Humidity Data: $humidityData'),
//           ],
//         ),
//       ),
//     );
//   }
// }