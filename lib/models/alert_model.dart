/// Modelo de datos para representar una alerta.
/// Este modelo se utiliza para almacenar información detallada sobre una alerta,
/// incluyendo su título, descripción, y fecha/hora de ocurrencia.
class AlertModel {
  final String? id; // Identificador único de la alerta (opcional).
  final String title; // Título de la alerta.
  final String description; // Descripción detallada de la alerta.
  final String minute; // Minuto del tiempo en el que ocurrió la alerta.
  final String hour; // Hora del tiempo en el que ocurrió la alerta.
  final String day; // Día del mes en el que ocurrió la alerta.
  final String month; // Mes en el que ocurrió la alerta.
  final String year; // Año en el que ocurrió la alerta.

  /// Constructor de la clase [AlertModel].
  /// - [id]: Identificador único opcional.
  /// - [title], [description], [minute], [hour], [day], [month], [year]:
  ///   Parámetros requeridos para inicializar la alerta.
  const AlertModel({
    this.id,
    required this.title,
    required this.description,
    required this.minute,
    required this.hour,
    required this.day,
    required this.month,
    required this.year,
  });

  /// Convierte la instancia de [AlertModel] a un mapa JSON.
  /// Este método es útil para serializar el objeto al guardar datos en una base
  /// de datos o enviarlos a un servidor.
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "minute": minute,
      "hour": hour,
      "day": day,
      "month": month,
      "year": year,
    };
  }

  /// Crea una instancia de [AlertModel] a partir de un mapa JSON.
  /// Este método se usa para deserializar datos obtenidos de una base de datos
  /// o de un servidor.
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      title: json['title'] ?? '', // Valor por defecto si es nulo.
      description: json['description'] ?? '', // Manejo de nulos.
      minute: json['minute'] ?? '',
      hour: json['hour'] ?? '',
      day: json['day'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
    );
  }
}
