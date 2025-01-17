import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smartclothingproject/functions/internet_connection_state_notifier.dart';
import 'package:smartclothingproject/functions/show_toast.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';

class ConnectivityService {
  // Declaración de la suscripción
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final mongoService = MongoService();

  // Método para iniciar el monitoreo de conectividad
  void startMonitoringConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      if (results.contains(ConnectivityResult.none)) {
        showToast(message: "No hay conexión a Internet.");
        InternetConnectionNotifier().updateInternetConnectionState(false);
      } else {
        // showToast(message: "Conexión a Internet restaurada.");
        InternetConnectionNotifier().updateInternetConnectionState(true);
      }
    });
  }

  // Método para detener el monitoreo de conectividad
  void stopMonitoringConnectivity() {
    _connectivitySubscription?.cancel();
  }
}
