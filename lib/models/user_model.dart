class UserModel {
  final String? id;
  final String email;
  final String? hashpwd;
  final String name;
  final String surname;
  final String age;
  final String gender;
  final String userType;
  final String phoneNumber;
  final String birthDate;

  const UserModel({
    this.id,
    required this.email,
    this.hashpwd,
    required this.name,
    required this.surname,
    required this.age,
    required this.userType,
    required this.gender,
    required this.phoneNumber,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "Hashpwd": hashpwd ?? '',
      "Name": name,
      "Surname": surname,
      "Age": age,
      "BirthDate": birthDate,
      "Gender": gender,
      "UserType": userType,
      "PhoneNumber": phoneNumber,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['Email'],
      hashpwd: json['Hashpwd'],
      name: json['Name'],
      surname: json['Surname'],
      // Asegurarse de que 'age' sea siempre un String
      age: json['Age'] is int
          ? json['Age'].toString() // Si 'Age' es int, convertirlo a String
          : (json['Age'] is String
              ? json['Age']
              : ''), // Si 'Age' es String, dejarlo como está, si es otro tipo o null, usar ''
      birthDate: json['BirthDate'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['BirthDate'])
              .toIso8601String()
          : (json['BirthDate'] ??
              ''), // Si es un String o null, mantenerlo tal cual
      gender: json['Gender'],
      userType: json['UserType'],
      phoneNumber: json['PhoneNumber'],
    );
  }
}
