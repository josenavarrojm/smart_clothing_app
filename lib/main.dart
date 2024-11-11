import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/firebase_options.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'functions/theme_notifier.dart';
import 'functions/connected_state_notifier.dart';
import 'package:smartclothingproject/views/loggedUserPage.dart';
import 'functions/persistance_data.dart';
import 'views/auth_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? lastPage = await getLastPage();

  // Restringir la orientación a vertical (portrait)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeNotifier()),
          ChangeNotifierProvider(create: (context) => ConnectionService()),
          ChangeNotifierProvider(create: (context) => BlDataNotifier()),
        ],
        child: MyApp(
          lastPage: lastPage,
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final String? lastPage;

  const MyApp({super.key, this.lastPage});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeNotifier.isLightTheme
          ? ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primaryColorLight: Colors.white,
              primaryColor: Colors.black,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: Colors.blueAccent,
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
      home: lastPage == 'userLoggedHome'
          ? const LoggedUserPage()
          : const AuthSwitcher(),
      // home: BluetoothDialog(),
    );
  }
}
