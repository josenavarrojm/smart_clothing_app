import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ladys_app/firebase_options.dart';
import 'package:ladys_app/views/loggedUserPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'functions/LastPage.dart';
import 'views/authUser.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  String? lastPage = await getLastPage();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp(lastPage: lastPage));
}

class MyApp extends StatelessWidget {

  final String? lastPage;

  MyApp({Key? key, this.lastPage}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColorLight: Colors.white,
        primaryColor: Colors.black,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        primaryColorDark: Color.fromRGBO(12, 32, 100, 1.0),
      ),
      debugShowCheckedModeBanner: false,
      home: lastPage == 'userLoggedHome' ? LoggedUserPage(): AuthSwitcher(),
    );
  }
}