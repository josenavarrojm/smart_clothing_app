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
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          // Agregar depuración
          print(
              'Notification ID: ${response.id}'); // Verifica si el ID es correcto
          print(
              'Action pressed: ${response.actionId}'); // Verifica la acción presionada

          // Verifica si se presionó la acción de "Descartar"
          if (response.actionId == 'Discard') {
            print("Notification discarded"); // Agregar depuración
            // Cancelar la notificación solo si el ID no es nulo
            if (response.id != null) {
              await _notificationsPlugin.cancel(
                  response.id!); // Usamos '!' para asegurar que no sea nulo
            }
          }
        }
      },
    );

    // Crear el canal de notificaciones
    await _createNotificationChannel();
  }

  /// Crear un canal de notificaciones (Android 8.0 o superior)
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'Default Notifications', // Nombre que aparecerá en las configuraciones del sistema
      description: 'Este canal se utiliza para notificaciones básicas.',
      importance: Importance.high,
    );

    // Crear el canal en el dispositivo Android
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
      'channel_id', // Este ID debe coincidir con el ID del canal
      'Default Notifications',
      channelDescription: 'Este canal se utiliza para notificaciones básicas.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // Para asegurarte de que suene
      enableVibration: true, // Para habilitar la vibración
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'Accept',
          'Aceptar',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'Discard',
          'Descartar',
          showsUserInterface: true,
        ),
      ],
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id, // ID único para cada notificación
      title.isNotEmpty ? title : 'Default Title', // Título de la notificación
      body.isNotEmpty ? body : 'Default Body', // Cuerpo de la notificación
      details,
    );
  }
}
