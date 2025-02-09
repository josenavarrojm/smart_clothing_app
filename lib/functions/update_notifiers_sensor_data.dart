import 'dart:convert';
import 'dart:math';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/models/local_notifications_service.dart';

/// Actualiza los datos del BlDataNotifier con la información proporcionada.
///
/// [data] es un mapa que contiene las claves esperadas para actualizar
/// el estado del BlDataNotifier. Si una clave está ausente o tiene un formato
/// incorrecto, se omite su actualización.
void updateNotifiersSensorData(Map<String, dynamic> data) {
  final notifier = BlDataNotifier();

  // Validación y actualización de datos
  void updateNotifier<T>(void Function(String) updateFunction, String key) {
    final value = data[key]?.toString();
    if (value != null) {
      updateFunction(value);
    }
  }

  updateNotifier(notifier.updateBpmData, "bpm");
  updateNotifier(notifier.updateTemperatureAmbData, "tempAmb");
  updateNotifier(notifier.updateTemperatureCorporalData, "tempCorp");
  // updateNotifier(notifier.updateHumidityData, "hum");
  updateNotifier(notifier.updateAccelerometerXData, "acelX");
  updateNotifier(notifier.updateAccelerometerYData, "acelY");
  updateNotifier(notifier.updateAccelerometerZData, "acelZ");
  updateNotifier(notifier.updateTimeData, "time");
  updateNotifier(notifier.updateDateTimeData, "created_at");

  // Decodificación de ECG
  if (data["ecg"] != null) {
    final ecgData = (jsonDecode(data["ecg"]) as List<dynamic>).map((value) {
      return value is double ? value : double.tryParse(value.toString()) ?? 0.0;
    }).toList();
    notifier.updateECGDataApp(ecgData);
  }
}

/// Activa una notificación si la temperatura corporal está fuera del rango normal.
Future<void> activateTemperatureCorporalAlert() async {
  final tempCorpMonitor =
      double.tryParse(BlDataNotifier().temperatureCorporalData);
  if (tempCorpMonitor == null) return;

  String? title;
  String? body;

  if (tempCorpMonitor > 37.5) {
    title = 'Alerta de temperatura corporal alta';
    body =
        'Tu temperatura corporal es alta (${tempCorpMonitor.toStringAsFixed(1)}°C). Esto podría ser un signo de fiebre. Considera consultar a un médico si persiste.';
  } else if (tempCorpMonitor < 35.0) {
    title = 'Alerta de temperatura corporal baja';
    body =
        'Tu temperatura corporal es baja (${tempCorpMonitor.toStringAsFixed(1)}°C). Esto podría ser un signo de hipotermia. Busca abrigo y atención médica si es necesario.';
  }

  if (title != null && body != null) {
    await _showNotification(title, body);
  }
}

/// Activa una notificación si el ritmo cardíaco está fuera del rango normal.
Future<void> activateBPMAlert() async {
  final bpmMonitor = double.tryParse(BlDataNotifier().bpmData);
  if (bpmMonitor == null) return;

  String? title;
  String? body;

  if (bpmMonitor > 100.0) {
    title = 'Alerta de ritmo cardíaco alto';
    body =
        'Su ritmo cardíaco es alto (${bpmMonitor.toStringAsFixed(1)} BPM). Esto podría ser un signo de taquicardia. Consulte a un médico si persiste.';
  } else if (bpmMonitor < 60.0) {
    title = 'Alerta de ritmo cardíaco bajo';
    body =
        'Su ritmo cardíaco es bajo (${bpmMonitor.toStringAsFixed(1)} BPM). Esto podría ser un signo de bradicardia. Consulte a un médico si persiste.';
  }

  if (title != null && body != null) {
    await _showNotification(title, body);
  }
}

/// Activa una notificación si la postura detectada no es correcta.
Future<void> activatePositionAlert() async {
  final positionMonitor = double.tryParse(BlDataNotifier().accelerometerXData);
  if (positionMonitor == null) return;

  if (positionMonitor < 0.0 || positionMonitor > 45.0) {
    await _showNotification(
      'Alerta de postura incorrecta',
      'Corrija su postura, su posición actual no es la adecuada.',
    );
  }
}

/// Muestra una notificación con el título y cuerpo proporcionados.
///
/// [title] es el título de la notificación.
/// [body] es el mensaje que se mostrará en la notificación.
Future<void> _showNotification(String title, String body) async {
  await LocalNotificationService.showNotification(
    id: Random().nextInt(100000),
    title: title,
    body: body,
  );
}
