import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smartclothingproject/functions/internet_connection_state_notifier.dart';
import 'package:smartclothingproject/functions/show_toast.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';

/// Servicio para monitorear el estado de conectividad a Internet.
/// Utiliza el paquete `connectivity_plus` para escuchar los cambios en el estado
/// de conexión y actualizar el estado global de conectividad.
class ConnectivityService {
  // Suscripción al stream de conectividad.
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Instancia del servicio MongoDB.
  final mongoService = MongoService();

  /// Inicia el monitoreo del estado de conectividad.
  /// Escucha los cambios en la conexión y actualiza el estado global de Internet.
  void startMonitoringConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      // Verifica si no hay conexión a Internet.
      if (results.contains(ConnectivityResult.none)) {
        showToast(
            message:
                "No hay conexión a Internet."); // Muestra un mensaje de advertencia.
        InternetConnectionNotifier().updateInternetConnectionState(
            false); // Actualiza el estado global.
      } else {
        // En caso de conexión, actualiza el estado global (puedes habilitar el toast si lo deseas).
        // showToast(message: "Conexión a Internet restaurada.");
        InternetConnectionNotifier().updateInternetConnectionState(true);
      }
    });
  }

  /// Detiene el monitoreo del estado de conectividad.
  /// Cancela la suscripción para evitar fugas de memoria.
  void stopMonitoringConnectivity() {
    _connectivitySubscription?.cancel();
  }
}
