import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:smartclothingproject/functions/LastPage.dart';
import 'package:smartclothingproject/views/loggedUserPage.dart';
import '../models/user_model.dart';
import 'package:flutter/services.dart';

String email = '';
String password = '';
String confirmPassword = '';
String name = '';
String surname = '';
int age = 0;
bool samePsw = false;
bool registerBtn = false;
bool loginBtn = false;
bool validEmail = true;
String? selectedUserType;
String? selectedGender;
DateTime? selectedDate;
final TextEditingController _dateController = TextEditingController();
bool obsTextConfirm = false;
final _formKey = GlobalKey<FormState>();
final _formKey2 = GlobalKey<FormState>();

const radiusNormal = 25.0;
const radiusFocus = 15.0;
const radiusBtn = 15.0;

FirebaseFirestore db = FirebaseFirestore.instance;

Future<bool> isEmailInUse(String email) async {
  final querySnapshot =
      await db.collection('users').where('Email', isEqualTo: email).get();

  return querySnapshot.docs.isNotEmpty;
}

// Creación y registro de usuarios en la base de datos
void saveUserToFirestore(BuildContext context) async {
  String hashPassword(String password) {
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  // Crear instancia de UserModel a partir de los datos del formulario
  UserModel newUser = UserModel(
    email: email,
    hashpwd: hashPassword(password),
    name: name,
    surname: surname,
    age: age,
    gender: selectedGender!,
    userType: selectedUserType!,
  );

  // Verificar si el correo ya está en uso
  if (await isEmailInUse(newUser.email)) {
    // Mostrar SnackBar si el correo ya está en uso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("El correo ya está en uso."),
        duration: Duration(seconds: 2), // Duración de la notificación
      ),
    );
    return; // Terminar la función si el correo ya está en uso
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ya puede iniciar sesión"),
        duration: Duration(seconds: 2), // Duración de la notificación
      ),
    );
  }

  // Guardar en Firestore si el correo no está en uso
  await db
      .collection("users")
      .add(newUser.toJson())
      .then((value) => print("Usuario agregado con ID: ${value.id}"))
      .catchError((error) => print("Error al agregar usuario: $error"));
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const LoginForm()));
}

// Lectura para la verificación de la existencia de usuarios en la base de datos e inicio de sesión
Future<void> loginUser(
    BuildContext context, String email, String password) async {
  bool verifyPassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }

  // Buscar el usuario en Firestore
  final QuerySnapshot result =
      await db.collection("users").where("Email", isEqualTo: email).get();

  // Verificar si se encontró algún usuario
  if (result.docs.isNotEmpty) {
    // Usuario encontrado, comprobar la contraseña
    final userData = result.docs.first.data() as Map<String, dynamic>;

    // Comprobar si la contraseña coincide
    if (verifyPassword(password, userData["Hashpwd"])) {
      // Mostrar SnackBar de éxito

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Inicio de sesión exitoso."),
          duration: Duration(seconds: 2),
        ),
      );
      LoggedUser(context);

      // Aquí puedes realizar la navegación o cualquier otra acción después del inicio de sesión
    } else {
      // Contraseña incorrecta
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contraseña incorrecta."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } else {
    // No se encontró ningún usuario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No existe un usuario con ese correo."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

void registerPage(context) {
  registerBtn = false;
  email = '';
  _dateController.clear();
  selectedDate = null;
  selectedUserType = null;
  selectedGender = null;
  password = '';
  confirmPassword = '';
  samePsw = false;
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const RegisterForm())); // Muestra el formulario de registro
}

void loginPage(context) {
  email = '';
  password = '';
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginForm())); // Muestra el formulario de inicio de sesión
}

void LoggedUser(context) {
  email = '';
  password = '';
  loginBtn = false;
  validEmail = false;
  saveLastPage('userLoggedHome');
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoggedUserPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const beginOffset = Offset(0.0, 1.0); // Comienza desde abajo
        const endOffset = Offset.zero; // Termina en el centro
        const curve = Curves.easeInOut;

        var offsetTween = Tween(begin: beginOffset, end: endOffset)
            .chain(CurveTween(curve: curve));
        var opacityTween =
            Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(offsetTween),
          child: FadeTransition(
            opacity: animation.drive(opacityTween),
            child: child,
          ),
        );
      },
    ),
    (Route<dynamic> route) => false, // Elimina todas las vistas anteriores
  );
}

class AuthSwitcher extends StatefulWidget {
  const AuthSwitcher({super.key});

  @override
  _AuthSwitcherState createState() => _AuthSwitcherState();
}

class _AuthSwitcherState extends State<AuthSwitcher> {
  bool isLogin = true; // Estado para saber cuál formulario mostrar

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    });

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(
                  80, 80, 220, 0.40), // Color inicial del gradiente
              Theme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(0.5), // Color final del gradiente
            ],
            begin:
                Alignment.topLeft, // Comienza en la esquina superior izquierda
            end:
                Alignment.bottomRight, // Termina en la esquina inferior derecha
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/ladys_logo.png',
                  width: 200,
                ),
                Text('Smarth Clothing',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        letterSpacing: 2))
              ],
            ),
            Column(
              children: [
                Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.07,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      email = '';
                      password = '';
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginForm(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin =
                                Offset(1.0, 0.0); // Comienza desde la derecha
                            const end = Offset.zero; // Termina en el centro
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    } // Muestra el formulario de inicio de sesión
                    ,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radiusBtn))),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.login),
                          ),
                        ]),
                  ),
                ),
                Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.07,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      registerBtn = false;
                      email = '';
                      _dateController.clear();
                      selectedDate = null;
                      selectedUserType = null;
                      selectedGender = null;
                      password = '';
                      confirmPassword = '';
                      samePsw = false;
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const RegisterForm(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin =
                                Offset(1.0, 0.0); // Comienza desde la derecha
                            const end = Offset.zero; // Termina en el centro
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                      // Muestra el formulario de registro
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radiusBtn))),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Registrarse',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.app_registration_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   backgroundColor: Colors.transparent,
        //   foregroundColor: Theme.of(context).primaryColor,
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AuthSwitcher(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin =
                      Offset(-1.0, 0.0); // Comienza desde la izquierda
                  const end = Offset.zero; // Termina en el centro
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
              (Route<dynamic> route) =>
                  false, // Elimina todas las vistas anteriores
            );
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              // registro de usuario
              width: screenWidth,
              height: screenHeight * 1,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  gradient: LinearGradient(
                colors: [
                  Colors.pink.withOpacity(0.25),
                  Colors.purple.withOpacity(0.25),
                  const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                  Colors.blue.withOpacity(0.25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Inicio de sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 12.0),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Theme.of(context).primaryColor,
                                ), // myIcon is a 48px-wide widget.
                              ),
                              labelText: 'Correo electrónico',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              suffixStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1.5),
                                  borderRadius:
                                      BorderRadius.circular(radiusFocus)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: (loginBtn && email == '')
                                          ? Colors.red
                                          : Theme.of(context).primaryColor,
                                      width: 0.75),
                                  borderRadius:
                                      BorderRadius.circular(radiusNormal)),
                            ),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu correo electrónico';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              validEmail = EmailValidator.validate(value);
                              email = value;
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 12.0),
                                child: Icon(Icons.password,
                                    color: Theme.of(context)
                                        .primaryColor), // myIcon is a 48px-wide widget.
                              ),
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              suffixStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1.5),
                                  borderRadius:
                                      BorderRadius.circular(radiusFocus)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: (loginBtn && email == '')
                                          ? Colors.red
                                          : Theme.of(context).primaryColor,
                                      width: 0.75),
                                  borderRadius:
                                      BorderRadius.circular(radiusNormal)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obsTextConfirm
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obsTextConfirm = !obsTextConfirm;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            obscureText: !obsTextConfirm,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                              if (confirmPassword == password &&
                                  confirmPassword.isNotEmpty &&
                                  password.isNotEmpty) {
                                samePsw = true;
                              } else {
                                samePsw = false;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 30.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radiusBtn))),
                            onPressed: () {
                              loginBtn = true;
                              if (loginBtn) {
                                if (email != '' &&
                                    validEmail &&
                                    password != '') {
                                  loginUser(context, email, password);
                                }
                              }
                              setState(() {});
                            },
                            child: const Text(
                              'Iniciar Sesión',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿No tienes una cuenta?',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextButton(
                              onPressed: () {
                                registerPage(context);
                              },
                              child: const Text(
                                'Registrarse',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 18 * 365)), //.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";

        // Calcula la edad
        final currentDate = DateTime.now();
        age = currentDate.year - picked.year;

        // Ajusta la edad si el cumpleaños de este año aún no ha pasado
        if (currentDate.month < picked.month ||
            (currentDate.month == picked.month &&
                currentDate.day < picked.day)) {
          age--;
        }

        print("Edad: $age años");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   foregroundColor: Theme.of(context).primaryColor,
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AuthSwitcher(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin =
                      Offset(-1.0, 0.0); // Comienza desde la izquierda
                  const end = Offset.zero; // Termina en el centro
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
              (Route<dynamic> route) =>
                  false, // Elimina todas las vistas anteriores
            );
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              // registro de usuario
              width: screenWidth,
              height: screenHeight * 1,
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  gradient: LinearGradient(
                colors: [
                  Colors.pink.withOpacity(0.25),
                  Colors.purple.withOpacity(0.25),
                  const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                  Colors.blue.withOpacity(0.25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 20),
                    child: Text(
                      'Registro de Usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Form(
                    key: _formKey2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Icon(Icons.text_format,
                                        color: Theme.of(context)
                                            .primaryColor), // myIcon is a 48px-wide widget.
                                  ),
                                  counterStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  labelText: 'Nombres',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  suffixStyle: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular(radiusFocus)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: (registerBtn && name == '')
                                              ? Colors.red
                                              : Theme.of(context).primaryColor,
                                          width: 0.75),
                                      borderRadius:
                                          BorderRadius.circular(radiusNormal))),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu nombre';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                name = value;
                                setState(() {});
                              },
                            )),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12.0),
                                  child: Icon(Icons.text_fields,
                                      color: Theme.of(context)
                                          .primaryColor), // myIcon is a 48px-wide widget.
                                ),
                                labelText: 'Apellidos',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                suffixStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (registerBtn && surname == '')
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                        width: 0.75),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal))),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tus apellidos';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              surname = value;
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12.0),
                                  child: Icon(Icons.email_outlined,
                                      color: Theme.of(context)
                                          .primaryColor), // myIcon is a 48px-wide widget.
                                ),
                                labelText: 'Correo electrónico',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                suffixStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (registerBtn && email == '') ||
                                                !validEmail
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                        width: 0.75),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal))),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu correo electrónico';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Por favor ingresa un correo electrónico válido';
                              } else {
                                true;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              validEmail = EmailValidator.validate(value);
                              email = value;
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 12.0),
                                child: Icon(Icons.password,
                                    color: Theme.of(context)
                                        .primaryColor), // myIcon is a 48px-wide widget.
                              ),
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              suffixStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1.5),
                                  borderRadius:
                                      BorderRadius.circular(radiusFocus)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(radiusNormal),
                                  borderSide: BorderSide(
                                    color: (registerBtn && password == '')
                                        ? Colors.red
                                        : confirmPassword.isNotEmpty &&
                                                password.isNotEmpty
                                            ? samePsw
                                                ? Colors.green
                                                : Colors.red
                                            : Theme.of(context).primaryColor,
                                    width: 0.75,
                                  )),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    obsTextConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () {
                                  setState(() {
                                    obsTextConfirm = !obsTextConfirm;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            obscureText: !obsTextConfirm,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                              if (confirmPassword == password &&
                                  confirmPassword.isNotEmpty &&
                                  password.isNotEmpty) {
                                samePsw = true;
                              } else {
                                samePsw = false;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 12.0),
                                child: Icon(Icons.password,
                                    color: Theme.of(context)
                                        .primaryColor), // myIcon is a 48px-wide widget.
                              ),
                              labelText: 'Confirme su contraseña',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              suffixStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1.5),
                                  borderRadius:
                                      BorderRadius.circular(radiusFocus)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(radiusNormal),
                                  borderSide: BorderSide(
                                    color: (registerBtn &&
                                            confirmPassword == '')
                                        ? Colors.red
                                        : confirmPassword.isNotEmpty &&
                                                password.isNotEmpty
                                            ? samePsw
                                                ? Colors.green
                                                : Colors.red
                                            : Theme.of(context).primaryColor,
                                    width: 0.75,
                                  )),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    obsTextConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () {
                                  setState(() {
                                    obsTextConfirm = !obsTextConfirm;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            obscureText: !obsTextConfirm,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor confirma tu contraseña';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              confirmPassword = value;
                              if (confirmPassword == password &&
                                  confirmPassword.isNotEmpty &&
                                  password.isNotEmpty) {
                                samePsw = true;
                              } else {
                                samePsw = false;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(40),
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(Icons.wc_outlined,
                                            color: Theme.of(context)
                                                .primaryColor), // myIcon is a 48px-wide widget.
                                      ),
                                      labelText: 'Género',
                                      labelStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (registerBtn &&
                                                      ![
                                                        'Masculino',
                                                        'Femenino',
                                                        '29 tipos de gays'
                                                      ].contains(
                                                          selectedGender))
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              width: 0.75),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal))),
                                  value: selectedGender,
                                  items: <String>[
                                    'Masculino',
                                    'Femenino',
                                    'Otro'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).primaryColor),
                                        overflow: TextOverflow
                                            .ellipsis, // Agrega puntos suspensivos si es muy largo
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedGender = newValue!;
                                    });
                                  },
                                  validator: (value) => value == null
                                      ? 'Por favor selecciona una opción'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: TextFormField(
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(Icons.date_range_outlined,
                                            color: Theme.of(context)
                                                .primaryColor), // myIcon is a 48px-wide widget.
                                      ),
                                      labelText: 'Fecha de Nacimiento',
                                      labelStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (registerBtn &&
                                                      selectedDate == null)
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              width: 0.75),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal))),
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor selecciona tu fecha de nacimiento';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: DropdownButtonFormField<String>(
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12.0),
                                  child: Icon(Icons.assignment_ind_outlined,
                                      color: Theme.of(context)
                                          .primaryColor), // myIcon is a 48px-wide widget.
                                ),
                                labelText: 'Selecciona un tipo de usuario',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1.5),
                                  borderRadius:
                                      BorderRadius.circular(radiusFocus),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: (registerBtn &&
                                                ![
                                                  'Administrador',
                                                  'Médico',
                                                  'Paciente'
                                                ].contains(selectedUserType))
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                        width: 0.75),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal))),
                            value: selectedUserType,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            items: <String>['Empleador', 'SGSST', 'Trabajador']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              selectedUserType = newValue!;
                              setState(() {});
                            },
                            iconEnabledColor: Theme.of(context).primaryColor,
                            validator: (value) => value == null
                                ? 'Por favor selecciona una opción'
                                : null,
                          ),
                        ),
                        if (selectedUserType == 'SGSST') UserMedic(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 40.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(radiusBtn))),
                            onPressed: () {
                              registerBtn = true;
                              if (registerBtn) {
                                if (samePsw &&
                                    name != '' &&
                                    surname != '' &&
                                    email != '' &&
                                    validEmail &&
                                    selectedUserType != '' &&
                                    selectedGender != '' &&
                                    age >= 18) {
                                  saveUserToFirestore(context);
                                }
                              }
                              setState(() {});
                            },
                            child: const Text(
                              'Registrarse',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes una cuenta?',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {
                                loginPage(
                                    context); // Muestra el formulario de inicio de sesión
                              },
                              child: const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    letterSpacing: 1.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class UserMedic extends StatelessWidget {
  const UserMedic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: '0000-0000-0000',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(radiusFocus),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 0.75),
                borderRadius: BorderRadius.circular(radiusNormal))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingreso tu código de registro médico';
          }
          return null;
        },
        onChanged: (value) {
          email = value; // Asegúrate de que email esté definido
        },
      ),
    );
  }
}
