// Función para actualizar BlDataNotifier
import 'dart:convert';
import 'dart:math';

import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/models/local_notifications_service.dart';

void updateNotifiersSensorData(Map<String, dynamic> data) {
  BlDataNotifier().updatebpmData(data["bpm"].toString());
  BlDataNotifier().updateTemperatureAmbData(data["tempAmb"].toString());
  BlDataNotifier().updateTemperatureCorporalData(data["tempCorp"].toString());
  BlDataNotifier().updateHumidityData(data["hum"].toString());
  BlDataNotifier().updateAccelerometerXData(data["acelX"].toString());
  BlDataNotifier().updateAccelerometerYData(data["acelY"].toString());
  BlDataNotifier().updateAccelerometerZData(data["acelZ"].toString());
  BlDataNotifier().updatetimeData(data["time"].toString());
  BlDataNotifier().updateDateTimeData(data["created_at"]);
  BlDataNotifier().updateHistoricoTempCorp(data["tempCorp"].toDouble());
  BlDataNotifier().updateHistoricoBPM(data["bpm"].toDouble());

  // Decodificar `ecg` desde String a List<dynamic>
  final ecgData = (jsonDecode(data["ecg"]) as List<dynamic>).map((value) {
    return value is double ? value : double.tryParse(value.toString()) ?? 0.0;
  }).toList();

  BlDataNotifier().updateECGDataApp(ecgData);
}

void activateTemperatureCorporalAlert() async {
  final double tempCorpMonitor =
      double.tryParse(BlDataNotifier().temperatureCorporalData)!;

  if (tempCorpMonitor > 37.5) {
    await LocalNotificationService.showNotification(
      id: Random().nextInt(100000),
      title: 'Alerta de temperatura corporal alta',
      body:
          'Tu temperatura corporal es alta (${tempCorpMonitor.toStringAsFixed(1)}°C). Esto podría ser un signo de fiebre. Considera consultar a un médico si persiste.',
    );
  } else if (tempCorpMonitor < 35.0) {
    await LocalNotificationService.showNotification(
      id: Random().nextInt(100000),
      title: 'Alerta de temperatura corporal baja',
      body:
          'Tu temperatura corporal es baja (${tempCorpMonitor.toStringAsFixed(1)}°C). Esto podría ser un signo de hipotermia. Busca abrigo y atención médica si es necesario.',
    );
  } else {
    // No mostrar notificaciones si la temperatura está dentro del rango normal.
  }
}

void activateBPMAlert() async {
  final double bpmMonitor = double.tryParse(BlDataNotifier().bpmData)!;

  if (bpmMonitor > 100.0) {
    await LocalNotificationService.showNotification(
      id: Random().nextInt(100000),
      title: 'Alerta de ritmo cardíaco alto',
      body:
          'Su ritmo cardíaco es alto (${bpmMonitor.toStringAsFixed(1)} BPM). Esto podría ser un signo de taquicardia. Consulte a un médico si persiste.',
    );
  } else if (bpmMonitor < 60.0) {
    await LocalNotificationService.showNotification(
      id: Random().nextInt(100000),
      title: 'Alerta de ritmo cardíaco bajo',
      body:
          'Su ritmo cardíaco es bajo (${bpmMonitor.toStringAsFixed(1)} BPM). Esto podría ser un signo de bradicardia. Consulte a un médico si persiste.',
    );
  } else {
    // No mostrar notificaciones si el BPM está dentro del rango normal.
  }
}

void activatePositionAlert() async {
  final double positionMonitor =
      double.tryParse(BlDataNotifier().accelerometerXData)!;

  if (positionMonitor <= 45.0 && positionMonitor >= 0.0) {
    // No mostrar notificaciones si el BPM está dentro del rango normal.
  } else {
    await LocalNotificationService.showNotification(
      id: Random().nextInt(100000),
      title: 'Alerta de postura incorrecta',
      body: 'Corrija su postura, su posición actual no es la adecuada.',
    );
  }
}
