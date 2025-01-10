class AlertModel {
  final String? id;
  final String title;
  final String description;
  final String minute;
  final String hour;
  final String day;
  final String month;
  final String year;

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

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      minute: json['minute'] ?? '',
      hour: json['hour'] ?? '',
      day: json['day'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
    );
  }
}
