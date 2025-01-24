import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/alerts_notifier.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/internet_connection_state_notifier.dart';
import 'package:smartclothingproject/functions/loader_logged.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/models/conectivity_detector.dart';
import 'package:smartclothingproject/models/local_notifications_service.dart';
import 'package:smartclothingproject/views/admin_page.dart';
import 'package:smartclothingproject/views/auth_user.dart';
import 'functions/theme_notifier.dart';
import 'functions/ble_connected_state_notifier.dart';
import 'package:smartclothingproject/views/logged_user_page.dart';
import 'functions/persistance_data.dart';

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Solicitar permiso de notificaciones
  await requestNotificationPermission();

  // Inicializar el servicio de notificaciones locales
  await LocalNotificationService.initialize();

  // Crear instancia del servicio MongoDB
  final mongoService = MongoService();

  // Obtener la última página visitada
  String? lastPage = await getLastPage();

  // Restringir la orientación a vertical (portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Crear instancia del servicio de conectividad
  final connectivityService = ConnectivityService();
  connectivityService.startMonitoringConnectivity();

  // Ejecutar la aplicación
  runApp(
    MultiProvider(
      providers: [
        Provider<MongoService>.value(value: mongoService),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => BleConnectionService()),
        ChangeNotifierProvider(create: (context) => BlDataNotifier()),
        ChangeNotifierProvider(create: (context) => AlertsNotifier()),
        ChangeNotifierProvider(
            create: (context) => InternetConnectionNotifier()),
        ChangeNotifierProvider(create: (context) => AuthState()),
      ],
      child: MyApp(lastPage: lastPage),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? lastPage;

  const MyApp({super.key, this.lastPage});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'SmartClothing App',
      theme: themeNotifier.isLightTheme
          ? ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
              primaryColor: const Color.fromARGB(255, 5, 74, 145),
              primaryColorLight: const Color.fromARGB(255, 129, 164, 205),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: const Color.fromARGB(255, 62, 124, 177),
                  tertiary: const Color.fromARGB(255, 241, 115, 0)),
            )
          : ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 67, 67, 67),
              primaryColor: const Color.fromARGB(255, 5, 74, 145),
              primaryColorLight: const Color.fromARGB(255, 129, 164, 205),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: const Color.fromARGB(255, 62, 124, 177),
                  tertiary: const Color.fromARGB(255, 241, 115, 0)),
            ),
      debugShowCheckedModeBanner: false,
      home: lastPage == 'userLoggedHome'
          ? const LoggedUserPage()
          : lastPage == 'AdminPage'
              ? const AdminPage()
              : const AuthSwitcher(),
    );
  }
}
