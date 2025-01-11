class UserModel {
  final String? id;
  // ignore: non_constant_identifier_names
  final String user_id;
  final String name;
  final String surname;
  final String phoneNumber;
  final String email;
  final String gender;
  final String birthDate;
  final String age;

  final String cedula;
  final String cedulaDate;
  final String departamentoCedula;
  final String ciudadCedula;

  final String scholarityLevel;
  final String occupation;
  final String maritalStatus;
  final String numberOfChildren;
  final String peopleEconomlyDepend;

  final String stateOfResidence;
  final String cityOfResidence;
  final String barrioOfResidence;
  final String addressOfResidence;

  final String bloodType;
  final String eps;
  final String arl;
  final String pensionFondo;

  const UserModel({
    this.id,
    // ignore: non_constant_identifier_names
    required this.user_id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.age,
    required this.cedula,
    required this.cedulaDate,
    required this.departamentoCedula,
    required this.ciudadCedula,
    required this.scholarityLevel,
    required this.occupation,
    required this.maritalStatus,
    required this.numberOfChildren,
    required this.peopleEconomlyDepend,
    required this.stateOfResidence,
    required this.cityOfResidence,
    required this.barrioOfResidence,
    required this.addressOfResidence,
    required this.bloodType,
    required this.eps,
    required this.arl,
    required this.pensionFondo,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": user_id,
      "Name": name,
      "Surname": surname,
      "PhoneNumber": phoneNumber,
      "Email": email,
      "Gender": gender,
      "BirthDate": birthDate,
      "Age": age,
      "Cedula": cedula,
      "DateCedula": cedulaDate,
      "DepartamentoCedula": departamentoCedula,
      "CiudadCedula": ciudadCedula,
      "ScholarityLevel": scholarityLevel,
      "Occupation": occupation,
      "MaritalStatus": maritalStatus,
      "NumberOfChildren": numberOfChildren,
      "PeopleEconomlyDepend": peopleEconomlyDepend,
      "StateOfResidence": stateOfResidence,
      "CityOfResidence": cityOfResidence,
      "BarrioOfResidence": barrioOfResidence,
      "AddressOfResidence": addressOfResidence,
      "BloodType": bloodType,
      "EPS": eps,
      "ARL": arl,
      "PensionFondo": pensionFondo,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] ?? '',
      email: json['Email'] ?? '',
      name: json['Name'] ?? '',
      surname: json['Surname'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      gender: json['Gender'] ?? '',
      birthDate: json['BirthDate']?.toString() ?? '',
      age: json['Age']?.toString() ?? '0', // Convertir null o número a String
      cedula: json['Cedula'] ?? '',
      cedulaDate: json['DateCedula']?.toString() ?? '',
      departamentoCedula: json['DepartamentoCedula'] ?? '',
      ciudadCedula: json['CiudadCedula'] ?? '',
      scholarityLevel: json['ScholarityLevel'] ?? '',
      occupation: json['Occupation'] ?? '',
      maritalStatus: json['MaritalStatus'] ?? '',
      numberOfChildren: json['NumberOfChildren'] ?? '',
      peopleEconomlyDepend: json['PeopleEconomlyDepend'] ?? '',
      stateOfResidence: json['StateOfResidence'] ?? '',
      cityOfResidence: json['CityOfResidence'] ?? '',
      barrioOfResidence: json['BarrioOfResidence'] ?? '',
      addressOfResidence: json['AddressOfResidence'] ?? '',
      bloodType: json['BloodType'] ?? '',
      eps: json['EPS'] ?? '',
      arl: json['ARL'] ?? '',
      pensionFondo: json['PensionFondo'] ?? '',
    );
  }
}
