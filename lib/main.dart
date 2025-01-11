import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/alerts_notifier.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/loader_logged.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/models/local_notifications_service.dart';
import 'package:smartclothingproject/views/auth_user.dart';
import 'functions/theme_notifier.dart';
import 'functions/connected_state_notifier.dart';
import 'package:smartclothingproject/views/logged_user_page.dart';
import 'functions/persistance_data.dart';

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  requestNotificationPermission();
  await LocalNotificationService.initialize();

  // Crear instancia del servicio MongoDB
  final mongoService = MongoService();
  await mongoService.connect();

  // Obtener la última página visitada
  String? lastPage = await getLastPage();

  // Restringir la orientación a vertical (portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Ejecutar la aplicación
  runApp(
    MultiProvider(
      providers: [
        Provider<MongoService>.value(value: mongoService),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => ConnectionService()),
        ChangeNotifierProvider(create: (context) => BlDataNotifier()),
        ChangeNotifierProvider(create: (context) => AlertsNotifier()),
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
      // Selección de página inicial según la última visitada
      home: lastPage == 'userLoggedHome'
          ? const LoggedUserPage()
          : const AuthSwitcher(), // Cambia a AuthSwitcher si es necesario
      // home: const AuthSwitcher(), // Cambia a AuthSwitcher si es necesario
    );
  }
}
