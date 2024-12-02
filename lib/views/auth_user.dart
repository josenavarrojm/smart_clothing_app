import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartclothingproject/functions/persistance_data.dart';
import 'package:smartclothingproject/handlers/data_base_handler.dart';
import 'package:smartclothingproject/views/loggedUserPage.dart';
import '../models/user_model.dart';
import 'package:flutter/services.dart';

String email = '';
String password = '';
String confirmPassword = '';
String name = '';
String surname = '';
String phoneNumber = '';
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

const radiusNormal = 50.0;
const radiusFocus = 20.0;
const radiusBtn = 50.0;

const durationAnimation = Duration(milliseconds: 250);

FirebaseFirestore db = FirebaseFirestore.instance;

Future<bool> isEmailInUse(String email) async {
  final querySnapshot =
      await db.collection('users').where('Email', isEqualTo: email).get();

  return querySnapshot.docs.isNotEmpty;
}

// Creación y registro de usuarios en la base de datos
String hashPassword(String password) {
  final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  return hashedPassword;
}

void saveUserToFirestore(BuildContext context) async {
  UserModel newUser = UserModel(
    email: email,
    hashpwd: hashPassword(password),
    name: name,
    surname: surname,
    age: age.toString(),
    birthDate: _dateController.text,
    gender: selectedGender!,
    userType: selectedUserType!,
    phoneNumber: phoneNumber,
  );
  // Crear instancia de UserModel a partir de los datos del formulario

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
    // Guardar en Firestore si el correo no está en uso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Registro Exitoso"),
        duration: Duration(seconds: 2), // Duración de la notificación
      ),
    );
  }
  await db
      .collection("users")
      .add(newUser.toJson())
      .then((value) => print("Usuario agregado con ID: ${value.id}"))
      .catchError((error) => print("Error al agregar usuario: $error"));

  // Guardar datos en SQLite
  await DatabaseHandler.instance.saveOrUpdateUser(newUser.toJson());
  LoggedUser(context);
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
      //Registrar los datos de usuario en la base de datos local
      await DatabaseHandler.instance.saveOrUpdateUser(userData);
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
              RegisterForm())); // Muestra el formulario de registro
}

void loginPage(context) {
  email = '';
  password = '';
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginForm())); // Muestra el formulario de inicio de sesión
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
      pageBuilder: (context, animation, secondaryAnimation) => LoggedUserPage(),
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
  const AuthSwitcher({
    super.key,
  });

  @override
  _AuthSwitcherState createState() => _AuthSwitcherState();
}

class _AuthSwitcherState extends State<AuthSwitcher> {
  bool isLogin = true; // Estado para saber cuál formulario mostrar
  bool _showCard = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: _showCard
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent));
    });

    return Scaffold(
      body: Stack(children: [
        AnimatedContainer(
          duration: durationAnimation,
          alignment: _showCard ? Alignment.center : Alignment.center,
          padding: _showCard
              ? const EdgeInsets.only(bottom: 250)
              : const EdgeInsets.only(bottom: 0),
          height: screenHeight,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/ladys_logo.png',
                    width: 200,
                  ),
                  Text('Smart Clothing',
                      style: GoogleFonts.pattaya(
                          fontSize: 50,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary))
                ],
              ),
              Column(
                children: [
                  AnimatedContainer(
                    duration: durationAnimation,
                    width: _showCard ? screenWidth * 0.2 : screenWidth * 0.9,
                    height:
                        _showCard ? screenHeight * 0.02 : screenHeight * 0.085,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showCard =
                              !_showCard; // Alterna la visibilidad del Card
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(radiusBtn),
                          side: BorderSide(width: 0.0), // Borde negro
                        ),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Ingresar',
                              style: GoogleFonts.pattaya(
                                  fontSize: 30,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w100,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.login,
                              color: Theme.of(context).primaryColor),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedPositioned(
            duration: durationAnimation,
            curve: Curves.easeInOut,
            bottom: _showCard ? 0 : -screenHeight * 0.6, // Animación
            left: 0,
            right: 0,
            child: Card(
              margin: const EdgeInsets.all(0),
              elevation: 0.0,
              // color: Colors.transparent,
              color: Theme.of(context).colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),

              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).colorScheme.secondary,
                  //   borderRadius: BorderRadius.circular(40),
                  // ),
                  child: Column(children: [
                    Container(
                      height: screenHeight * 0.4,
                      decoration: BoxDecoration(
                        // color: Colors.pink,
                        borderRadius: BorderRadius.circular(50),
                      ), // Altura del Card
                      child: Center(child: const LoginForm()), // Tu formulario
                    ),
                    FloatingActionButton(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            radiusBtn), // Esquinas redondeadas
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _showCard = !_showCard;
                        });
                      },
                      child: Icon(
                        Icons.arrow_downward_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ])),
            )),
      ]),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // return Scaffold(
    // appBar: AppBar(
    //   elevation: 0,
    //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   backgroundColor: Colors.transparent,
    //   foregroundColor: Theme.of(context).primaryColor,
    // ),
    // floatingActionButton: FloatingActionButton(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(50), // Esquinas redondeadas
    //   ),
    //   splashColor: const Color.fromRGBO(155, 100, 255, 1.0),
    //   hoverElevation: 5,
    //   elevation: 0,
    //   backgroundColor: const Color.fromRGBO(10, 120, 255, 1.0),
    //   onPressed: () {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation, secondaryAnimation) =>
    //             AuthSwitcher(),
    //         transitionsBuilder:
    //             (context, animation, secondaryAnimation, child) {
    //           const begin =
    //               Offset(-1.0, 0.0); // Comienza desde la izquierda
    //           const end = Offset.zero; // Termina en el centro
    //           const curve = Curves.easeInOut;

    //           var tween = Tween(begin: begin, end: end)
    //               .chain(CurveTween(curve: curve));

    //           return SlideTransition(
    //             position: animation.drive(tween),
    //             child: child,
    //           );
    //         },
    //       ),
    //       (Route<dynamic> route) =>
    //           false, // Elimina todas las vistas anteriores
    //     );
    //   },
    //   child: AnimatedContainer(
    //     duration: durationAnimation,
    //     width: 60,
    //     height: 60,
    //     alignment: Alignment.center,
    //     child: const Icon(Icons.arrow_back_ios_new),
    //   ),
    // ),
    // body: SingleChildScrollView(
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          // registro de usuario
          // width: screenWidth,
          // height: screenHeight * 1,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            // color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(radiusBtn),
            //     gradient: LinearGradient(
            //   colors: [
            //     Colors.pink.withOpacity(0.25),
            //     Colors.purple.withOpacity(0.25),
            //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
            //     Colors.blue.withOpacity(0.25),
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Inicio de sesión ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pattaya(
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
                            padding:
                                const EdgeInsetsDirectional.only(start: 12.0),
                            child: Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).primaryColor,
                            ), // myIcon is a 48px-wide widget.
                          ),
                          labelText: 'Correo electrónico',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          suffixStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.5),
                              borderRadius: BorderRadius.circular(radiusFocus)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: (loginBtn && email == '')
                                      ? Colors.red
                                      : Theme.of(context).primaryColor,
                                  width: 0.75),
                              borderRadius:
                                  BorderRadius.circular(radiusNormal)),
                        ),
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
                            padding:
                                const EdgeInsetsDirectional.only(start: 12.0),
                            child: Icon(Icons.password,
                                color: Theme.of(context)
                                    .primaryColor), // myIcon is a 48px-wide widget.
                          ),
                          labelText: 'Contraseña',
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          suffixStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.5),
                              borderRadius: BorderRadius.circular(radiusFocus)),
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
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30.0),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(radiusBtn))),
                        onPressed: () {
                          loginBtn = true;
                          if (loginBtn) {
                            if (email != '' && validEmail && password != '') {
                              loginUser(context, email, password);
                            }
                          }
                          setState(() {});
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.pattaya(
                              fontSize: 25,
                              fontWeight: FontWeight.w100,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       '¿No tienes una cuenta?',
                    //       style: TextStyle(
                    //           fontSize: 18,
                    //           color: Theme.of(context).primaryColor,
                    //           fontWeight: FontWeight.w400),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         registerPage(context);
                    //       },
                    //       child: const Text(
                    //         'Registrarse',
                    //         style: TextStyle(
                    //             fontSize: 18,
                    //             color: Colors.lightBlue,
                    //             fontWeight: FontWeight.w600,
                    //             letterSpacing: 0.5),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Esquinas redondeadas
            ),
            splashColor: const Color.fromRGBO(155, 100, 255, 1.0),
            hoverElevation: 5,
            elevation: 0,
            backgroundColor: const Color.fromRGBO(10, 120, 255, 1.0),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AuthSwitcher(),
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
            child: AnimatedContainer(
              duration: durationAnimation,
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back_ios_new),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              // registro de usuario
              width: screenWidth,
              height: screenHeight * 1.2,
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
                        // phoneNumber
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
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12.0),
                                  child: Icon(Icons.numbers,
                                      color: Theme.of(context)
                                          .primaryColor), // myIcon is a 48px-wide widget.
                                ),
                                labelText: 'Celular',
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
                                        color: (registerBtn &&
                                                phoneNumber == '')
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                        width: 0.75),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal))),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa un número válido';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              phoneNumber = value;
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
                          child: DropdownButtonFormField<String>(
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(40),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12.0),
                                  child: Icon(Icons.wc_outlined,
                                      color: Theme.of(context)
                                          .primaryColor), // myIcon is a 48px-wide widget.
                                ),
                                labelText: 'Sexo',
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
                                                  'Masculino',
                                                  'Femenino',
                                                ].contains(selectedGender))
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                        width: 0.75),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal))),
                            value: selectedGender,
                            items: <String>['Masculino', 'Femenino', 'Otro']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor),
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
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12.0),
                                  child: Icon(Icons.date_range_outlined,
                                      color: Theme.of(context)
                                          .primaryColor), // myIcon is a 48px-wide widget.
                                ),
                                labelText: 'Fecha de nacimiento',
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
                                                selectedDate == null)
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                        width: 0.75),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal))),
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
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: DropdownButtonFormField<String>(
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
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
                            onPressed: () async {
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
