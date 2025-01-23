import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartclothingproject/functions/alerts_notifier.dart';
import 'package:smartclothingproject/functions/get_date_now.dart';
import 'package:smartclothingproject/functions/persistance_data.dart';
import 'package:smartclothingproject/handlers/data_base_handler.dart';

/// Servicio para gestionar notificaciones locales en Flutter.
/// Utiliza `flutter_local_notifications` para mostrar notificaciones,
/// guardar datos relacionados y actualizar contadores de alertas.
class LocalNotificationService {
  // Instancia del plugin de notificaciones.
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializa el servicio de notificaciones locales.
  /// Configura los ajustes iniciales y crea un canal de notificaciones para Android.
  static Future<void> initialize() async {
    // Configuración para Android.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración general para todas las plataformas.
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // Inicialización del plugin con un callback para manejar las respuestas.
    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Depuración y manejo de acciones al recibir respuestas.
        if (response.payload != null) {
          print('Notification ID: ${response.id}');
          print('Action pressed: ${response.actionId}');

          // Manejo de la acción "Descartar".
          if (response.actionId == 'Discard') {
            print("Notification discarded");
            if (response.id != null) {
              await _notificationsPlugin.cancel(response.id!);
            }
          }
        }
      },
    );

    // Crear el canal de notificaciones.
    await _createNotificationChannel();
  }

  /// Crea un canal de notificaciones en Android (requerido para Android 8.0 o superior).
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id', // ID único del canal.
      'Default Notifications', // Nombre visible en las configuraciones del sistema.
      description: 'Este canal se utiliza para notificaciones básicas.',
      importance: Importance.high, // Importancia del canal.
    );

    // Crear el canal en dispositivos Android.
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Muestra una notificación local.
  /// Además, guarda los detalles de la alerta en la base de datos y actualiza el contador de alertas.
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Configuración específica para Android.
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id', // ID del canal (debe coincidir con el canal creado).
      'Default Notifications', // Nombre visible en la notificación.
      channelDescription: 'Este canal se utiliza para notificaciones básicas.',
      importance: Importance.max, // Máxima prioridad.
      priority: Priority.high, // Alta prioridad.
      playSound: true, // Habilitar sonido.
      enableVibration: true, // Habilitar vibración.
      actions: <AndroidNotificationAction>[
        // Acciones personalizadas.
        AndroidNotificationAction(
          'Accept', // Acción "Aceptar".
          'Aceptar',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'Discard', // Acción "Descartar".
          'Descartar',
          showsUserInterface: true,
        ),
      ],
    );

    // Configuración general para todas las plataformas.
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // Mostrar la notificación.
    await _notificationsPlugin.show(
      id,
      title.isNotEmpty ? title : 'Default Title', // Título de la notificación.
      body.isNotEmpty ? body : 'Default Body', // Cuerpo de la notificación.
      details,
    );

    // Obtener la fecha y hora actual.
    Map<String, dynamic> currentDate = await dateNow();

    // Guardar la alerta en la base de datos.
    final dbHandler = DatabaseHandler.instance;
    Map<String, dynamic> newAlert = {
      'title': title,
      'description': body,
      'minute': currentDate['minute'] ?? '0',
      'hour': currentDate['hour'] ?? '0',
      'day': currentDate['day'] ?? '0',
      'month': currentDate['month'] ?? '0',
      'year': currentDate['year'] ?? '0',
    };

    await dbHandler.saveAlert(newAlert);
    print(newAlert);
    print('Alerta guardada!');

    // Actualizar el contador de alertas.
    String newAlertsValue = AlertsNotifier().newAlerts;
    if (newAlertsValue.isNotEmpty && int.tryParse(newAlertsValue) != null) {
      int newAlertsInt = int.parse(newAlertsValue);
      AlertsNotifier().updateNewAlerts('${newAlertsInt + 1}');
      saveAlerts(AlertsNotifier().newAlerts);
    } else {
      saveAlerts('1');
      AlertsNotifier()
          .updateNewAlerts('1'); // Valor inicial en caso de no haber alertas.
    }
  }
}
