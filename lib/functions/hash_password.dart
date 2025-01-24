import 'package:bcrypt/bcrypt.dart';

String hashPassword(String password) {
  final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  return hashedPassword;
}
