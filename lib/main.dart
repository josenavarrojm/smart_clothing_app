import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/loaderLogged.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/views/auth_user.dart';
import 'functions/theme_notifier.dart';
import 'functions/connected_state_notifier.dart';
import 'package:smartclothingproject/views/loggedUserPage.dart';
import 'functions/persistance_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
              scaffoldBackgroundColor: Colors.white,
              primaryColorLight: Colors.white,
              primaryColor: const Color.fromARGB(255, 255, 255, 255),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color.fromARGB(255, 0, 0, 0),
              ),
            )
          : ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primaryColor: Colors.white,
              primaryColorDark: const Color.fromRGBO(12, 32, 100, 1.0),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.blue[900],
              ),
            ),
      debugShowCheckedModeBanner: false,
      // Selección de página inicial según la última visitada
      home: lastPage == 'userLoggedHome'
          ? const LoggedUserPage()
          : const AuthSwitcher(), // Cambia a AuthSwitcher si es necesario
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
// import 'package:smartclothingproject/functions/loaderLogged.dart';
// import 'package:smartclothingproject/handlers/mongo_database.dart';
// // import 'package:smartclothingproject/views/demographic_profile.dart';
// import 'functions/theme_notifier.dart';
// import 'functions/connected_state_notifier.dart';
// import 'package:smartclothingproject/views/loggedUserPage.dart';
// // import 'views/auth_user.dart';
// import 'functions/persistance_data.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Crear instancia del servicio MongoDB
//   final mongoService = MongoService();
//   await mongoService.connect();

//   String? lastPage = await getLastPage();

//   // Restringir la orientación a vertical (portrait)
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]).then((_) {
//     runApp(
//       mongoService: mongoService,
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => ThemeNotifier()),
//           ChangeNotifierProvider(create: (context) => ConnectionService()),
//           ChangeNotifierProvider(create: (context) => BlDataNotifier()),
//           ChangeNotifierProvider(create: (context) => AuthState()),
//         ],
//         child: MyApp(
//           lastPage: lastPage,
//         ),
//       ),
//     );
//   });
// }

// class MyApp extends StatelessWidget {
//   final String? lastPage;
//   final MongoService mongoService;

//   const MyApp({super.key, this.lastPage, required this.mongoService});

//   @override
//   Widget build(BuildContext context) {
//     final themeNotifier = Provider.of<ThemeNotifier>(context);
//     return MaterialApp(
//       title: 'SmartClothing App',
//       theme: themeNotifier.isLightTheme
//           ? ThemeData(
//               scaffoldBackgroundColor: Colors.white,
//               primaryColorLight: Colors.white,
//               primaryColor: const Color.fromARGB(255, 255, 255, 255),
//               colorScheme: ColorScheme.fromSwatch().copyWith(
//                 secondary: const Color.fromARGB(255, 0, 0, 0),
//               ),
//             )
//           : ThemeData(
//               scaffoldBackgroundColor: Colors.black,
//               primaryColor: Colors.white,
//               primaryColorDark: const Color.fromRGBO(12, 32, 100, 1.0),
//               colorScheme: ColorScheme.fromSwatch().copyWith(
//                 secondary: Colors.blue[900],
//               ),
//             ),
//       debugShowCheckedModeBanner: false,
//       // home: lastPage == 'userLoggedHome'
//       //     ? const LoggedUserPage()
//       //     : const AuthSwitcher(),
//       home: const LoggedUserPage(),
//       // home: const DemographicProfileWorker(),
//     );
//   }
// }
