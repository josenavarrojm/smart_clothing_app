// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import './blecontroller.dart';

// // // // void main() =_GT_ runApp(GetMaterialApp(home: Home()));

// // // // class Home extends StatelessWidget {
// // // // @override
// // // // Widget build(context) {
// // // // final BleController ble = Get.put(BleController());
// // // // return Scaffold(

// // // // appBar: AppBar(title: Text('BLE demo')),
// // // // body: Center(child: Column(children:[

// // // // SizedBox(height:50),

// // // // ElevatedButton(
// // // // onPressed: ble.connect,
// // // // child: Obx(() =_GT_ Text('${ble.status.value}',
// // // // style: TextStyle(
// // // // fontWeight: FontWeight.bold,
// // // // fontSize:50)))),

// // // // SizedBox(height:50),

// // // // Obx(() =_GT_ Text('${ble.temperature.value}',
// // // // style: TextStyle(
// // // // fontWeight: FontWeight.bold,
// // // // fontSize:200))),
// // // // ])),);}}

// // // // // filename: blecontroller.dart
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// // // // import 'package:get/get.dart';
// // // // import 'dart:async';
// // // // import 'dart:typed_data';

// // // //   class BleController {
// // // //   final frb = FlutterReactiveBle();
// // // //   final devId = '9C:9C:1F:C5:11:7A'; // use nrf connect from playstore to find id
// // // //   late StreamSubscription LT_ConnectionStateUpdate_GT c;
// // // //   late QualifiedCharacteristic rx;
// // // //   var status = 'connect to bluetooth'.obs;
// // // //   var temperature = '0'.obs;

// // // //   void connect() async {

// // // //   status.value = 'connecting...';
// // // //   c = frb.connectToDevice(id: devId).listen((state){
// // // //   if (state.connectionState == DeviceConnectionState.connected){
// // // //   status.value = 'connected!';

// // // //   rx = QualifiedCharacteristic(
// // // //   serviceId: Uuid.parse("181A"),
// // // //   characteristicId: Uuid.parse("2A6E"),
// // // //   deviceId: devId);

// // // //   frb.subscribeToCharacteristic(rx).listen((data){
// // // //     temperature.value = data.toString();});
// // // //   }});}}

// // Los datos que estás recibiendo en consola son en realidad una representación en bytes de una cadena JSON. Para ver el mensaje como texto legible, debes convertir esta lista de bytes en una cadena de texto antes de interpretarla como JSON.

// // Aquí tienes cómo hacerlo en Flutter:

// // Convierte los datos de bytes a una cadena de texto.
// // Interpreta la cadena como JSON para extraer los datos.
// // Modifiquemos el código de la suscripción para decodificar los datos antes de imprimirlos:

// // dart
// // Copiar código
// // StreamSubscription<List<int>>? subscribeToCharacteristic({
// //   required String deviceId,
// //   required Uuid serviceId,
// //   required Uuid characteristicId,
// // }) {
// //   final characteristic = QualifiedCharacteristic(
// //     serviceId: serviceId,
// //     characteristicId: characteristicId,
// //     deviceId: deviceId,
// //   );

// //   final subscription = flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
// //     (data) {
// //       try {
// //         // Convertir la lista de bytes en una cadena de texto
// //         final decodedData = String.fromCharCodes(data);
// //         print("Datos recibidos como texto: $decodedData");

// //         // Opcional: Si deseas convertir el JSON a un mapa para acceder a los valores específicos
// //         final jsonData = jsonDecode(decodedData);
// //         print("Datos decodificados: $jsonData");

// //         // Puedes acceder a cada campo individualmente si lo necesitas
// //         print("Temperatura: ${jsonData['temperature']}");
// //       } catch (e) {
// //         print("Error al decodificar los datos: $e");
// //       }
// //     },
// //     onError: (error) {
// //       print("Error de suscripción: $error");
// //     },
// //   );

// //   return subscription; // Retorna la suscripción para poder cancelarla después
// // }
// // Explicación de los Cambios
// // String.fromCharCodes(data): Convierte la lista de bytes (data) en una cadena de texto que representa el JSON original.
// // jsonDecode(decodedData): Convierte la cadena de JSON en un mapa de Dart para que puedas acceder a los valores específicos.

// StringBuffer _receivedDataBuffer = StringBuffer();

// StreamSubscription<List<int>>? subscribeToCharacteristic({
//   required String deviceId,
//   required Uuid serviceId,
//   required Uuid characteristicId,
// }) {
//   final characteristic = QualifiedCharacteristic(
//     serviceId: serviceId,
//     characteristicId: characteristicId,
//     deviceId: deviceId,
//   );

//   // Suscripción al flujo de datos de la característica
//   final subscription =
//       flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
//     (data) {
//       print("Datos recibidos (sin procesar): $data");

//       try {
//         // Convertir el fragmento de datos recibido en texto
//         final decodedFragment = String.fromCharCodes(data);
//         print("Fragmento decodificado: $decodedFragment");

//         // Acumular el fragmento en el buffer
//         _receivedDataBuffer.write(decodedFragment);

//         // Verificar si el mensaje completo parece estar recibido
//         if (_receivedDataBuffer.toString().contains("\n")) {
//           final completeData = _receivedDataBuffer.toString();

//           // Eliminar el delimitador y procesar el JSON
//           final jsonString = completeData.replaceAll("\n", "");
//           final jsonData = jsonDecode(jsonString);
//           print("Datos decodificados: $jsonData");

//           // Limpia el buffer para la siguiente transmisión
//           _receivedDataBuffer.clear();

//           // Opcional: Puedes acceder a valores específicos del JSON
//           print("Temperatura: ${jsonData['temperature']}");
//         }
//       } catch (e) {
//         print("Error al decodificar los datos: $e");
//         // Limpia el buffer si hay un error
//         _receivedDataBuffer.clear();
//       }
//     },
//     onError: (error) {
//       print("Error de suscripción: $error");
//     },
//   );

//   return subscription; // Retorna la suscripción para poder cancelarla después
// }
