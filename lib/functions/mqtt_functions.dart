import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? client;
  MqttClientConnectionStatus? connectionState;

  // Broker mqtt connection
  Future<void> connect(final String broker, final int port, final String clientId, final String username, final String password) async {
    client = MqttServerClient(broker, clientId);
    client!.port = port;
    client!.logging(on: true);
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.onConnected = onConnected;

    // Mensaje de conexión con credenciales
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client!.connectionMessage = connMessage;

    try {
      print('Intentando conectar...');
      connectionState = await client!.connect();
      if (connectionState?.state == MqttConnectionState.connected) {
        print('Conexión exitosa');
      } else {
        print('Conexión fallida, estado: ${connectionState?.state}');
        disconnect();
      }
    } catch (e) {
      print('Error de conexión: $e');
      disconnect();
    }
  }


  void onConnected() {
    print('Conexión exitosa');
    subscribe('mqttservices/test'); // Suscribirse a un topic después de conectar
  }

  void onDisconnected() {
    print('Desconectado del broker');
  }

  void disconnect() {
    print('Desconectando...');
    client?.disconnect();
  }

  // Topic subscription
  void subscribe(String topic) {
    if (connectionState?.state == MqttConnectionState.connected) {
      print('Suscrito al topic $topic');
      client!.subscribe(topic, MqttQos.atMostOnce);
    } else {
      print('No se puede suscribir. Estado de conexión: ${connectionState?.state}');
    }
  }

  // Messages publisher
  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publicando en $topic: $message');
    client!.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void listenToMessages() {
    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMessage = messages[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      print('Mensaje recibido: $payload en el topic: ${messages[0].topic}');

      // Convertir el JSON a un objeto Map
      Map<String, dynamic> jsonMessage = jsonDecode(payload);
      // Ahora puedes acceder a los valores
      print('Alerta de temperatura: ${jsonMessage["temp_alert"]}');
      //print('Alerta de temperatura: ${jsonMessage["temp_alert"] == 1 ? 'Posible Fiebre' : jsonMessage["temp_alert"] == 2 ? 'Posible hipotermia': 'Normal'}');
    });
  }
}
