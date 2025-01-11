import 'package:flutter/services.dart' show rootBundle; // Para leer assets
import 'package:csv/csv.dart'; // Para procesar el CSV

Future<Map<String, List>> loadCsvData(String filePath) async {
  // Leer el archivo CSV desde los assets
  final rawData = await rootBundle.loadString(filePath);

  // Parsear el archivo CSV
  final List<List<dynamic>> csvData =
      const CsvToListConverter().convert(rawData);

  // Inicializar las listas para números de muestra (n) y valores (v)
  List<int> sampleNumbers = [];
  List<double> sampleValues = [];

  // Procesar cada fila del CSV, omitir la primera fila si es un encabezado
  for (var i = 0; i < csvData.length; i++) {
    final row = csvData[i]; // Fila actual
    sampleNumbers.add(row[0] as int); // Convertir n a entero
    sampleValues.add(row[1] as double); // Convertir v a doble
  }

  // Retornar las listas
  return {
    "sampleNumbers": sampleNumbers,
    "sampleValues": sampleValues,
  };
}
