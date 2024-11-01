class UserModel {
  final String? id;
  final String email;
  final String? hashpwd;
  final String name;
  final String surname;
  final int age;
  final String gender;
  final String userType;

  const UserModel({
    this.id,
    required this.email,
    this.hashpwd,
    required this.name,
    required this.surname,
    required this.age,
    required this.userType,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "Hashpwd": hashpwd,
      "Name": name,
      "Surname": surname,
      "Age": age,
      "Gender": gender,
      "UserType": userType,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['Email'],
      hashpwd: json['Hashpwd'],
      name: json['Name'],
      surname: json['Surname'],
      age: json['Age'],
      gender: json['Gender'],
      userType: json['UserType'],
    );
  }
}
