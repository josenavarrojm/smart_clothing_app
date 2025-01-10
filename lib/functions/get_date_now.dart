import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> dateNow() async {
  // Asegúrate de inicializar el formato de fecha
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';

  // Obtén la fecha y hora actuales
  DateTime now = DateTime.now();

  // Extrae los valores de minuto, hora, día, mes y año
  String minute = now.minute.toString();
  String hour = now.hour.toString();
  String day = now.day.toString();
  String month = now.month.toString();
  String year = now.year.toString();

  // Devuelve los valores en un mapa
  return {
    'minute': minute,
    'hour': hour,
    'day': day,
    'month': month,
    'year': year,
  };
}
