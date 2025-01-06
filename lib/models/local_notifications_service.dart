import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializar el servicio de notificaciones
  static Future<void> initialize() async {
    // Configuración para Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para todas las plataformas
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // Inicialización del plugin
    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notificación seleccionada: ${response.payload}");
      },
    );

    // Crear el canal de notificaciones
    await _createNotificationChannel();
  }

  /// Crear un canal de notificaciones (Android 8.0 o superior)
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id', // ID único del canal
      'Default Notifications', // Nombre del canal
      description: 'Este canal se utiliza para notificaciones básicas.',
      importance: Importance.high, // Importancia del canal
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Mostrar una notificación
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id', // Debe coincidir con el ID del canal
      'Default Notifications',
      channelDescription: 'Este canal se utiliza para notificaciones básicas.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id, // ID único para cada notificación
      title,
      body,
      details,
    );
  }
}
