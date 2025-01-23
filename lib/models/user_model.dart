/// Clase que representa el modelo de usuario con todos sus datos relevantes.
class UserModel {
  /// Identificador único opcional del usuario (usado para bases de datos locales o remotas).
  final String? id;

  /// Identificador único del usuario, requerido.
  final String user_id;

  /// Nombre del usuario.
  final String name;

  /// Apellido del usuario.
  final String surname;

  /// Número de teléfono del usuario.
  final String phoneNumber;

  /// Correo electrónico del usuario.
  final String email;

  /// Género del usuario.
  final String gender;

  /// Fecha de nacimiento del usuario en formato `YYYY-MM-DD`.
  final String birthDate;

  /// Edad del usuario en años.
  final String age;

  /// Número de cédula del usuario.
  final String cedula;

  /// Fecha de expedición de la cédula.
  final String cedulaDate;

  /// Departamento de expedición de la cédula.
  final String departamentoCedula;

  /// Ciudad de expedición de la cédula.
  final String ciudadCedula;

  /// Nivel de escolaridad del usuario.
  final String scholarityLevel;

  /// Ocupación del usuario.
  final String occupation;

  /// Estado civil del usuario.
  final String maritalStatus;

  /// Número de hijos que tiene el usuario.
  final String numberOfChildren;

  /// Número de personas que dependen económicamente del usuario.
  final String peopleEconomlyDepend;

  /// Estado de residencia del usuario.
  final String stateOfResidence;

  /// Ciudad de residencia del usuario.
  final String cityOfResidence;

  /// Barrio de residencia del usuario.
  final String barrioOfResidence;

  /// Dirección completa de residencia del usuario.
  final String addressOfResidence;

  /// Tipo de sangre del usuario.
  final String bloodType;

  /// EPS (Entidad Promotora de Salud) del usuario.
  final String eps;

  /// ARL (Administradora de Riesgos Laborales) del usuario.
  final String arl;

  /// Fondo de pensión al que pertenece el usuario.
  final String pensionFondo;

  /// Constructor de la clase [UserModel].
  const UserModel({
    this.id,
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

  /// Convierte la instancia del modelo a un mapa (`Map<String, dynamic>`).
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

  /// Crea una instancia de [UserModel] a partir de un mapa (`Map<String, dynamic>`).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] ?? '',
      email: json['Email'] ?? '',
      name: json['Name'] ?? '',
      surname: json['Surname'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      gender: json['Gender'] ?? '',
      birthDate: json['BirthDate']?.toString() ?? '',
      age: json['Age']?.toString() ?? '0', // Convierte null o número a String
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
