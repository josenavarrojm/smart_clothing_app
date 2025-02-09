import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/controllers/BLE/ble_device_connector.dart';
import 'package:smartclothingproject/controllers/BLE/ble_scanner.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/ble_connected_state_notifier.dart';
import 'package:smartclothingproject/functions/internet_connection_state_notifier.dart';
import 'package:smartclothingproject/functions/update_notifiers_sensor_data.dart';
import 'package:smartclothingproject/handlers/data_base_handler.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/models/user_model.dart';
import 'dart:convert';

final flutterReactiveBle = FlutterReactiveBle();

class BluetoothController {
  late final String userid;
  final UserModel user;
  final MongoService mongoService;
  final BleScanner _bleScanner;
  final BleDeviceConnector _deviceConnector;
  int bpmData = 0;
  int timeData = 0;
  double temperatureAmbData = 0.0;
  double temperatureCorporalData = 0.0;
  // double humidityData = 0.0;
  double accelerometerXData = 0.0;
  double accelerometerYData = 0.0;
  double accelerometerZData = 0.0;
  List<double> ecgDataReceived = [];
  List<double> ecgDataIDReceived = [];
  int timestamp = 0;
  String readData = '';
  List<Map<String, dynamic>> dataMongoDB = [];
  StreamSubscription<List<int>>? subscription;

  Map<String, dynamic> dataReceived = {
    "_id": ObjectId(),
    "bpm": 0,
    "tempAmb": 0,
    "tempCorp": 0,
    // "hum": 0,
    "acelX": 0,
    "acelY": 0,
    "acelZ": 0,
    "time": 0,
    "ecg": <double>[],
    "timestamp": "",
  };

  List<Map<String, dynamic>> parseEcgData(List<String> ecgDataReceived) {
    List<Map<String, dynamic>> parsedData = [];

    for (String data in ecgDataReceived) {
      // Match para extraer índice y valores
      final regex = RegExp(r"(\d+)\sECG:\s\[(.+)\]");
      final match = regex.firstMatch(data);

      if (match != null) {
        int index = int.parse(match.group(1)!);
        List<double> values = match
            .group(2)!
            .split(', ')
            .map((value) => double.parse(value))
            .toList();

        parsedData.add({"index": index, "values": values});
      }
    }

    return parsedData;
  }

  BluetoothController(BuildContext context, this.user)
      : mongoService = Provider.of<MongoService>(context, listen: false),
        _bleScanner = BleScanner(
          ble: flutterReactiveBle,
          logMessage: (message) {
            // print(message
          },
        ),
        _deviceConnector = BleDeviceConnector(
          ble: flutterReactiveBle,
          logMessage: (message) {
            // print(message);
          },
        ) {
    // Inicialización de userid después de que se asigna `user`
    userid = user.user_id;
    dataReceived["user_id"] = userid;
  }

  BleScanner get bleScanner => _bleScanner;

  Future<void> requestBluetoothActivation() async {
    var bluetoothState = await FlutterBluePlus.adapterState.first;
    if (bluetoothState == BluetoothAdapterState.on) {
      print('ENCENDIDOOOOOOOOOOOOOOOOOOOOOOO');
      BleConnectionService().updateBleStatus(true);
    }

    if (bluetoothState == BluetoothAdapterState.off) {
      await FlutterBluePlus.turnOn();
      BleConnectionService().updateBleStatus(true);
    }
  }

  void startScanning(List<Uuid> serviceIds) async {
    // String? deviceId =
    //     await getDeivceId(); // Obtiene ID del último dispositivo conectado
    // print(deviceId);
    // if (deviceId != null) {
    //   BleConnectionService().updateScanned(true);
    //   await connectToDevice(deviceId); // Intenta conectar
    //   bool isConnected = BleConnectionService().isConnected;
    //   print('VOY POR ACÁAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');

    //   if (isConnected) {
    //     print('ESTOY CONECTADDASKJDASHKFKJASHFHAKJSFHKJASKJFH');
    //     BleConnectionService().updateScanned(false);
    //     BleConnectionService().updateDeviceStatus(false);
    //     BleConnectionService().updateConnectionStatus(true);
    //     BleConnectionService().updateSuscriptionStatus(true);
    //     BleConnectionService().updateBleStatus(true);
    //   } else if (!isConnected) {
    //     print('NO HA FUNCIONADOOOOOOOOOO');
    //     // Si la conexión falla, inicia el escaneo
    //     _bleScanner.startScan(serviceIds);
    //   }
    // } else {
    //   print('NO HAY DEVICE IDDDDDDDDDDDDDDDDD');
    //   // Si no hay un dispositivo guardado, inicia el escaneo directamente
    //   BleConnectionService().updateScanned(true);
    //   _bleScanner.startScan(serviceIds);
    // }
    BleConnectionService().updateScanned(true);
    _bleScanner.startScan(serviceIds);
  }

  Future<void> stopScanning() async {
    await _bleScanner.stopScan();
  }

  Future<void> connectToDevice(String deviceId) async {
    await _deviceConnector.connect(deviceId, subscription);
  }

  StreamSubscription<List<int>>? subscribeToCharacteristic({
    required String deviceId,
    required Uuid serviceId,
    required Uuid characteristicId,
  }) {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceId,
      characteristicId: characteristicId,
      deviceId: deviceId,
    );

    // Suscripción al flujo de datos de la característica
    bool dataNoEmpty = false;
    subscription?.cancel();
    subscription =
        flutterReactiveBle.subscribeToCharacteristic(characteristic).listen(
      (data) async {
        if (data.isNotEmpty && !dataNoEmpty) {
          dataNoEmpty = true;
          BleConnectionService().updateSuscriptionStatus(true);
        }
        Fluttertoast.cancel();
        // Convertir el fragmento de datos recibido en texto
        final decodedFragment = String.fromCharCodes(data);
        // print(decodedFragment);
        // Verificar si el fragmento contiene la palabra 'temperature'
        if (decodedFragment.contains('time')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String valueReceived =
                parts[1].trim(); // .trim() elimina espacios extra
            timeData = double.parse(valueReceived).toInt();

            dataReceived["time"] = timeData;
          }
        } else if (decodedFragment.contains('BPM')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String valueReceived =
                parts[1].trim(); // .trim() elimina espacios extra
            bpmData = double.parse(valueReceived).toInt();

            dataReceived["bpm"] = bpmData;
            print("bpm: ${BlDataNotifier().bpmData}");
          }
        } else if (decodedFragment.contains('tempAmb')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String valueReceived =
                parts[1].trim(); // .trim() elimina espacios extra
            temperatureAmbData = double.parse(valueReceived);

            dataReceived["tempAmb"] = temperatureAmbData;
            print(
                "Temperatura Ambiente: ${BlDataNotifier().temperatureAmbData}");
          }
        } else if (decodedFragment.contains('tempCorp')) {
          // Separar la cadena por el delimitador ":"
          if (!BleConnectionService().isSuscripted) {}
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            if (parts[1].trim() == 'None') {
            } else {
              // Extraer el valor de temperatura y limpiarlo
              String valueReceived =
                  parts[1].trim(); // .trim() elimina espacios extra
              temperatureCorporalData = double.parse(valueReceived);

              dataReceived["tempCorp"] = temperatureCorporalData;
              print(
                  "Temperatura corporal: ${BlDataNotifier().temperatureCorporalData}");
            }
          }
          // } else if (decodedFragment.contains('hum')) {
          //   // Separar la cadena por el delimitador ":"
          //   if (!BleConnectionService().isSuscripted) {}
          //   var parts = decodedFragment.split(':');

          //   // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          //   if (parts.length > 1) {
          //     // Extraer el valor de temperatura y limpiarlo
          //     String valueReceived =
          //         parts[1].trim(); // .trim() elimina espacios extra
          //     humidityData = double.parse(valueReceived);

          //     dataReceived["hum"] = humidityData;
          //     // print("Humedad: ${BlDataNotifier().humidityData}");
          //   }
        } else if ((decodedFragment.contains('acelX1'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelXValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerXData = double.parse(accelXValue);

            dataReceived["acelX"] = accelerometerXData;
            // print("Ángulo X1: ${BlDataNotifier().accelerometerXData}");
          }
        } else if ((decodedFragment.contains('acelX2'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelYValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerYData = double.parse(accelYValue);

            dataReceived["acelY"] = accelerometerYData;
            // print("Ángulo X2: ${BlDataNotifier().accelerometerYData}");
          }
        } else if ((decodedFragment.contains('acelZ'))) {
          // Separar la cadena por el delimitador ":"
          var parts = decodedFragment.split(':');

          // Asegurarnos de que hay al menos dos partes (la variable y el valor)
          if (parts.length > 1) {
            // Extraer el valor de temperatura y limpiarlo
            String accelZValue =
                parts[1].trim(); // .trim() elimina espacios extra
            accelerometerZData = double.parse(accelZValue);

            dataReceived["acelZ"] = accelerometerZData;
            // print("Ángulo Z: ${BlDataNotifier().accelerometerZData}");
          }
        } else if (decodedFragment.contains('ECG')) {
          // Limitar la lista a 2500 datos
          if (ecgDataIDReceived.length >= 2500) {
            ecgDataIDReceived.removeRange(0, ecgDataIDReceived.length - 2500);
          } else if (BlDataNotifier().ecgData.length < 2500) {
            if (decodedFragment.contains(':')) {
              var parts = decodedFragment.split(':');

              if (parts.length > 1) {
                // Asegúrate de que parts[0] tiene datos y es diferente al último leído
                var prefix = parts[0].split(' ').first;
                if (!ecgDataIDReceived.contains(double.parse(prefix))) {
                  ecgDataIDReceived.add(double.parse(prefix));
                  // Validar si hay datos dentro de corchetes
                  final match = RegExp(r'\[(.+)\]').firstMatch(parts[1]);
                  if (match != null) {
                    String cleanData = match
                        .group(1)!; // Extraer datos dentro de los corchetes
                    try {
                      List<double> values = cleanData
                          .split(",") // Divide los valores por comas
                          .map((value) =>
                              double.parse(value.trim())) // Convierte a double
                          .toList();

                      // Agregar valores a la lista y notificar
                      ecgDataReceived.addAll(values);
                      BlDataNotifier().updateECGData(ecgDataReceived);
                      BlDataNotifier().updateECGDataIDApp(ecgDataIDReceived);
                    } catch (e) {
                      print("Error al parsear los datos: $e");
                    }
                  }
                }
              }
            } else {
              print("Fragmento inválido: $decodedFragment");
            }
          }
        } else if ((decodedFragment.contains('Send'))) {
          var parts = decodedFragment.split(':');
          if (readData != parts[0]) {
            readData = parts[0];
            dataReceived["_id"] = ObjectId();

            // Convertir `ecgData` en String usando jsonEncode
            dataReceived["ecg"] = jsonEncode(BlDataNotifier().ecgData);

            await initializeDateFormatting('es_ES', null);
            timestamp = DateTime.now().millisecondsSinceEpoch.toInt();
            dataReceived["timestamp"] = timestamp;
            // DateTime fecha = DateTime.fromMillisecondsSinceEpoch(timestamp);
            // dataReceived["created_at"] =
            //     DateFormat('EEE, MMM d, yyyy - hh:mm a').format(fecha);
            // Intl.defaultLocale = 'es_ES';
            // dataReceived["created_at"] =
            //     DateFormat('EEE, MMM d, yyyy - hh:mm a').format(DateTime.now());

            if (BlDataNotifier().ecgData.isNotEmpty) {
              print('=====================');
              readData = '';

              try {
                final dbHandler = DatabaseHandler.instance;

                // Verificar conexión a Internet
                if (InternetConnectionNotifier().internetConnectionState) {
                  await mongoService.connect();

                  try {
                    // Guardar datos no sincronizados en MongoDB
                    final unsyncedData =
                        await dbHandler.getSensorDataNotOnMongoDB();
                    if (unsyncedData.isNotEmpty) {
                      for (var element in unsyncedData) {
                        try {
                          // Crear una copia mutable del elemento
                          final mutableElement =
                              Map<String, dynamic>.from(element);

                          // Asegurarse de que _id sea un formato válido
                          if (mutableElement['_id'] is String) {
                            final idString = mutableElement['_id'];

                            // Verificar y limpiar si tiene formato ObjectId("...")
                            if (idString.startsWith('ObjectId(') &&
                                idString.endsWith(')')) {
                              // Extraer solo la parte hexadecimal
                              mutableElement['_id'] =
                                  idString.substring(10, idString.length - 2);
                            }

                            // Convertir a ObjectId
                            mutableElement['_id'] =
                                ObjectId.fromHexString(mutableElement['_id']);
                          }

                          mutableElement.remove('onMongoDB');

                          // Subir a MongoDB
                          await mongoService.insertDocument(
                              mutableElement, "data");

                          // Actualizar el estado en SQLite a `true` (1)
                          await dbHandler.updateSensorDataSyncStatus(
                              mutableElement['id'], true);
                        } catch (e) {
                          print("Error al sincronizar datos: $e");
                        }
                      }
                    }

                    // Insertar nuevo dato en MongoDB
                    await mongoService.insertDocument(dataReceived, "data");

                    // Leer datos de MongoDB
                    final filter = {"user_id": dataReceived["user_id"]};

                    dataMongoDB =
                        await mongoService.getDocuments("data", filter: filter);

                    List<double> bpmList = [];
                    List<double> tempCorpList = [];

                    for (var doc in dataMongoDB) {
                      if (doc.containsKey('bpm') && doc['bpm'] != null) {
                        bpmList.add((doc['bpm'] as num).toDouble());
                      }
                      if (doc.containsKey('tempCorp') &&
                          doc['tempCorp'] != null) {
                        tempCorpList.add((doc['tempCorp'] as num).toDouble());
                      }
                    }

                    dataMongoDB.last["timestamp"] =
                        dataMongoDB.last["timestamp"].toInt();

                    DateTime fecha = DateTime.fromMillisecondsSinceEpoch(
                        (dataMongoDB.last["timestamp"]));

                    dataMongoDB.last.remove('timestamp');
                    dataMongoDB.last["created_at"] =
                        DateFormat('EEE, MMM d, yyyy - hh:mm a').format(fecha);

                    updateNotifiersSensorData(dataMongoDB.last);
                    BlDataNotifier().updateHistoricoBPM(bpmList);
                    BlDataNotifier().updateHistoricoTempCorp(tempCorpList);
                    // Activar alertas
                    activateTemperatureCorporalAlert();
                    activateBPMAlert();
                    activatePositionAlert();

                    // Marcar dato como sincronizado (convertir bool a int) y guardar en SQLite
                    dataReceived.remove('timestamp');
                    dataReceived['created_at'] =
                        DateFormat('EEE, MMM d, yyyy - hh:mm a').format(fecha);
                    dataReceived['onMongoDB'] = 1; // 1 para true
                    dataReceived['_id'] = dataReceived['_id'].toString();
                    await dbHandler.saveSensorData(dataReceived);
                  } finally {
                    await mongoService.disconnect(); // Garantizar desconexión
                  }
                } else {
                  // Sin conexión: guardar datos en SQLite
                  dataReceived['onMongoDB'] = 0; // 0 para false
                  dataReceived['_id'] = dataReceived['_id'].toString();
                  await dbHandler.saveSensorData(dataReceived);
                  print('Guardado Localmente');
                  readData = '';

                  final localData = await dbHandler.getAllSensorData();
                  updateNotifiersSensorData(localData.last);
                }
              } catch (e) {
                print("Error al procesar datos: $e");
              }
            }
            ecgDataIDReceived.clear();
            ecgDataReceived.clear();
          }
        }
      },
      onError: (error) {
        print("Error de suscripción: $error");
      },
    );

    return subscription; // Retorna la suscripción para poder cancelarla después
  }

  // Método para enviar datos a una característica
  Future<void> writeCharacteristic({
    required String deviceId,
    required Uuid serviceId,
    required Uuid characteristicId,
    required String value, // Cambié el tipo de `value` a String
  }) async {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceId,
      characteristicId: characteristicId,
      deviceId: deviceId,
    );

    // Convierte el texto en una lista de bytes (List<int>)
    List<int> valueBytes = utf8.encode(value);

    // Escribe el valor en la característica
    await flutterReactiveBle.writeCharacteristicWithResponse(
      characteristic,
      value: valueBytes,
    );

    print("Texto enviado: $value");
  }

  Future<void> dispose() async {
    await stopScanning();
    await _deviceConnector.dispose();
    await _bleScanner.dispose();
  }
}
