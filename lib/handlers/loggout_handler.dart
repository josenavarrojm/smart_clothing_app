import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smartclothingproject/controllers/BLE/ble_device_connector.dart';
import 'package:smartclothingproject/functions/persistance_data.dart';
import 'package:smartclothingproject/handlers/data_base_handler.dart';
import 'package:smartclothingproject/views/auth_user.dart';

void logoutHandler(BuildContext context, int selectedIndex) async {
  if (selectedIndex != 1) {
    String? deviceId = await getDeivceId();
    BleDeviceConnector(
            ble: FlutterReactiveBle(),
            logMessage: (message) {
              // print(message
            })
        .disconnect(deviceId!);
    saveDeviceId('');

    await DatabaseHandler.instance.deleteUser();
    await DatabaseHandler.instance.clearAlerts();
    await DatabaseHandler.instance.clearSensorData();
    saveAlerts('');
    saveLastPage('AuthSwitch');
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthSwitcher(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0); // Comienza desde la izquierda
          const end = Offset.zero; // Termina en el centro
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
      (Route<dynamic> route) => false, // Elimina todas las vistas anteriores
    );
  }
}
