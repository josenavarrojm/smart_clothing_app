import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLastPage(String pageName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_page', pageName); // Guarda el nombre de la vista
}

Future<String?> getLastPage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_page'); // Obtiene el nombre de la vista
}
