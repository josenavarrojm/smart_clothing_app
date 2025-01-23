import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Obtiene la fecha y hora actuales en el formato de la región `es_ES`.
///
/// Devuelve un mapa con los valores de minuto, hora, día, mes y año.
/// Los valores de minuto y hora están formateados con dos dígitos para mayor consistencia.
Future<Map<String, dynamic>> dateNow() async {
  // Inicializa el formato de fecha para el idioma español (España).
  await initializeDateFormatting('es_ES', null);
  Intl.defaultLocale = 'es_ES';

  // Obtiene la fecha y hora actuales.
  DateTime now = DateTime.now();

  // Extrae y formatea los componentes de la fecha y hora.
  String minute = now.minute.toString().padLeft(2, '0'); // Asegura 2 dígitos.
  String hour = now.hour.toString().padLeft(2, '0'); // Asegura 2 dígitos.
  String day = now.day.toString().padLeft(2, '0');
  String month = now.month.toString().padLeft(2, '0');
  String year = now.year.toString();

  // Retorna los valores como un mapa.
  return {
    'minute': minute,
    'hour': hour,
    'day': day,
    'month': month,
    'year': year,
  };
}
