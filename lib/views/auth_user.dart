// ignore_for_file: use_build_context_synchronously

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/loaderLogged.dart';
import 'package:smartclothingproject/functions/persistance_data.dart';
import 'package:smartclothingproject/handlers/data_base_handler.dart';
import 'package:smartclothingproject/views/loggedUserPage.dart';
import '../models/user_model.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';

String codeSession = '';
String password = '';
String name = '';
String surname = '';
String phoneNumber = '';
String email = '';
String? selectedGender;
DateTime? selectedDate;
int age = 0;
final TextEditingController _dateController = TextEditingController();

String cedula = '';
DateTime? selectedDateCedula;
final TextEditingController _dateControllerCedula = TextEditingController();
String departamentoCedula = '';
String ciudadCedula = '';

String selectedScholarityLevel = '';
String occupation = '';
String selectedMaritalStatus = '';
String numberOfChildren = '';
String peopleEconomlyDepend = '';

String stateOfResidence = '';
String cityOfResidence = '';
String barrioOfResidence = '';
String addressOfResidence = '';

String bloodType = '';
String eps = '';
String arl = '';
String pensionFondus = '';

final _formKey00 = GlobalKey<FormState>();
final _formKey0 = GlobalKey<FormState>();
final _formKey = GlobalKey<FormState>();
final _formKey1 = GlobalKey<FormState>();
final _formKey2 = GlobalKey<FormState>();
final _formKey3 = GlobalKey<FormState>();
final _formKey4 = GlobalKey<FormState>();

const marginCustom = EdgeInsets.symmetric(horizontal: 0.0, vertical: 0);

const spaceSizedBox = SizedBox(
  height: 8,
);

String selectedProfession = '';

bool nextPage = false;
bool loginBtn = false;
bool validEmail = true;
bool obsTextConfirm = false;

const radiusNormal = 50.0;
const radiusFocus = 20.0;
const radiusBtn = 50.0;

const durationAnimation = Duration(milliseconds: 250);

FirebaseFirestore db = FirebaseFirestore.instance;

// Creación y registro de usuarios en la base de datos
String hashPassword(String password) {
  final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  return hashedPassword;
}

void saveDemographicProfileOnMongo(BuildContext context) async {
  final mongoService = Provider.of<MongoService>(context, listen: false);

  UserModel newUser = UserModel(
      user_id: codeSession,
      name: name,
      surname: surname,
      email: email,
      age: age.toString(),
      birthDate: _dateController.text,
      gender: selectedGender!,
      phoneNumber: phoneNumber,
      cedula: cedula,
      cedulaDate: _dateControllerCedula.text,
      departamentoCedula: departamentoCedula,
      ciudadCedula: ciudadCedula,
      scholarityLevel: selectedScholarityLevel,
      occupation: occupation,
      maritalStatus: selectedMaritalStatus,
      numberOfChildren: numberOfChildren,
      peopleEconomlyDepend: peopleEconomlyDepend,
      stateOfResidence: stateOfResidence,
      cityOfResidence: cityOfResidence,
      barrioOfResidence: barrioOfResidence,
      addressOfResidence: addressOfResidence,
      bloodType: bloodType,
      eps: eps,
      arl: arl,
      pensionFondo: pensionFondus);

  await mongoService.updateDocument(codeSession, newUser.toJson(), 'users');

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Registro Exitoso"),
      duration: Duration(seconds: 2), // Duración de la notificación
    ),
  );
  // Guardar datos en SQLite
  await DatabaseHandler.instance.saveOrUpdateUser(newUser.toJson());
  // LoggedUser(context,);

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

// Lectura para la verificación de la existencia de usuarios en la base de datos e inicio de sesión
// Future<void> loginUser(
//     BuildContext context, String email, String password) async {
//   bool verifyPassword(String password, String hashedPassword) {
//     return BCrypt.checkpw(password, hashedPassword);
//   }

//   // Buscar el usuario en Firestore
//   final QuerySnapshot result =
//       await db.collection("users").where("Email", isEqualTo: email).get();

//   // Verificar si se encontró algún usuario
//   if (result.docs.isNotEmpty) {
//     // Usuario encontrado, comprobar la contraseña
//     final userData = result.docs.first.data() as Map<String, dynamic>;

//     // Comprobar si la contraseña coincide
//     if (verifyPassword(password, userData["Hashpwd"])) {
//       //Registrar los datos de usuario en la base de datos local
//       await DatabaseHandler.instance.saveOrUpdateUser(userData);
//       // Mostrar SnackBar de éxito
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Inicio de sesión exitoso."),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       LoggedUser(context);

//       // Aquí puedes realizar la navegación o cualquier otra acción después del inicio de sesión
//     } else {
//       // Contraseña incorrecta
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Contraseña incorrecta."),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   } else {
//     // No se encontró ningún usuario
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("No existe un usuario con ese correo."),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
// }

Future<void> signInUser(
    BuildContext context, String codeSession, String password) async {
  final mongoService = Provider.of<MongoService>(context, listen: false);
  // Filtro para buscar el usuario con el `user_id` especificado
  BlDataNotifier().updateUserID(codeSession);
  final filter = {"user_id": codeSession};
  final users = await mongoService.getDocuments("users", filter: filter);

  if (users.isNotEmpty) {
    final user = users.first;
    user.remove('_id');
    if (user.length <= 3) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DemographicProfileWorker(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const beginOffset = Offset(0.0, 1.0); // Comienza desde abajo
            const endOffset = Offset.zero; // Termina en el centro
            const curve = Curves.easeInOut;

            var offsetTween = Tween(begin: beginOffset, end: endOffset)
                .chain(CurveTween(curve: curve));
            var opacityTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

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
    } else {
      print('estoy acá');
      print(user);
      await DatabaseHandler.instance.saveOrUpdateUser(user);
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
            var opacityTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

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

    // if (user['password'] == password) {
    //   // Lógica para iniciar sesión
    //   print('Inicio de sesión exitoso para: ${user['name']}');
    // } else {
    //   print('Contraseña incorrecta');
    // }
  } else {
    print('Usuario no encontrado');
  }

  // loginBtn = true;
  // bool verifyPassword(String password, String hashedPassword) {
  //   return BCrypt.checkpw(password, hashedPassword);
  // }

  // // Buscar el usuario en Firestore
  // final QuerySnapshot result = await db
  //     .collection("users")
  //     .where("UserCode", isEqualTo: codeSession)
  //     .get();

  // // Verificar si se encontró algún usuario
  // if (result.docs.isNotEmpty) {
  //   // Usuario encontrado, comprobar la contraseña
  //   final userData = result.docs.first.data() as Map<String, dynamic>;

  //   // Comprobar si la contraseña coincide
  //   if (verifyPassword(password, userData["Hashpwd"])) {
  //     //Registrar los datos de usuario en la base de datos local
  //     // await DatabaseHandler.instance.saveOrUpdateUser(userData);
  //     // Mostrar SnackBar de éxito
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Inicio de sesión exitoso."),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     loggedUser(context, userData["DataCompleted"]);

  //     // Aquí puedes realizar la navegación o cualquier otra acción después del inicio de sesión
  //   } else {
  //     // Contraseña incorrecta
  //     loginBtn = false;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Contraseña incorrecta."),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // } else {
  //   // No se encontró ningún usuario
  //   loginBtn = false;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text("Las credenciales de acceso no son válidas."),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }
}

void registerPage(context) {
  nextPage = false;
  email = '';
  _dateController.clear();
  selectedDate = null;
  selectedGender = null;
  password = '';
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const DemographicProfileWorker())); // Muestra el formulario de registro
}

// void loginPage(context) {
//   email = '';
//   password = '';
//   Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               LoginForm())); // Muestra el formulario de inicio de sesión
// }

void loggedUser(context, bool DataCompleted) {
  email = '';
  codeSession = '';
  password = '';
  loginBtn = false;
  validEmail = false;
  if (DataCompleted) {
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
          var opacityTween = Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: curve));

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
  } else {
    saveLastPage('demographicProfile');
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DemographicProfileWorker(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const beginOffset = Offset(0.0, 1.0); // Comienza desde abajo
          const endOffset = Offset.zero; // Termina en el centro
          const curve = Curves.easeInOut;

          var offsetTween = Tween(begin: beginOffset, end: endOffset)
              .chain(CurveTween(curve: curve));
          var opacityTween = Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: curve));

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
  final TextEditingController _codeSessionController = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _codeSessionController.dispose(); // Liberar recursos al destruir el widget
    super.dispose();
  }

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
          statusBarColor: Theme.of(context).scaffoldBackgroundColor));
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
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/ladys_logo.png',
                    width: 200,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('Smart Clothing',
                      style: GoogleFonts.lexend(
                          fontSize: 35,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).primaryColor))
                ],
              ),
              Column(
                children: [
                  AnimatedContainer(
                    duration: durationAnimation,
                    width: _showCard ? screenWidth * 0.2 : screenWidth * 0.65,
                    height:
                        _showCard ? screenHeight * 0.02 : screenHeight * 0.085,
                    // margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showCard =
                              !_showCard; // Alterna la visibilidad del Card
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: Theme.of(context).primaryColor,
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
                              style: GoogleFonts.lexend(
                                  fontSize: 25,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.login,
                              color: Theme.of(context).scaffoldBackgroundColor),
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
            bottom: _showCard ? 0 : -screenHeight * 0.9, // Animación
            left: 0,
            right: 0,
            child: Card(
                margin: const EdgeInsets.all(0),
                elevation: 0.0,
                // color: Colors.transparent,
                color: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    // decoration: BoxDecoration(
                    //   color: Theme.of(context).colorScheme.secondary,
                    //   borderRadius: BorderRadius.circular(40),
                    // ),
                    child: Consumer<AuthState>(
                        builder: (context, authState, child) {
                      return authState.loginBtn
                          ? Center(
                              child: Container(
                                height: screenHeight * 0.474,
                                decoration: BoxDecoration(
                                  // color: Colors.pink,
                                  borderRadius: BorderRadius.circular(50),
                                ), // Altura del Card
                                child: Center(
                                  child: LoadingAnimationWidget.waveDots(
                                    color: Theme.of(context).primaryColor,
                                    size: 50,
                                  ),
                                ), // Tu formulario
                              ),
                            )
                          : Column(children: [
                              Container(
                                height: screenHeight * 0.5,
                                decoration: BoxDecoration(
                                  // color: Colors.pink,
                                  borderRadius: BorderRadius.circular(50),
                                ), // Altura del Card
                                child: Center(
                                    child: LoginForm(
                                  controllerCodeSession: _codeSessionController,
                                  controllerPassword: _controllerPassword,
                                )), // Tu formulario
                              ),
                              FloatingActionButton(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      radiusBtn), // Esquinas redondeadas
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                onPressed: () {
                                  codeSession = '';
                                  password = '';
                                  setState(() {
                                    _showCard = !_showCard;
                                    FocusScope.of(context).unfocus();
                                    _controllerPassword.clear();
                                    _codeSessionController.clear();
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_downward_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 40,
                                ),
                              )
                            ]);
                    })))),
      ]),
    );
  }
}

class LoginForm extends StatefulWidget {
  final TextEditingController controllerCodeSession;
  final TextEditingController controllerPassword;
  const LoginForm({
    super.key,
    required this.controllerCodeSession,
    required this.controllerPassword,
  });

  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radiusBtn),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Inicio de Sesión',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                      fontSize: 30,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
              Form(
                key: _formKey00,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 5),
                      child: TextFormField(
                        controller: widget.controllerCodeSession,
                        keyboardType:
                            TextInputType.text, // Activa el teclado numérico
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 12.0),
                            child: Icon(
                              Icons.vpn_key_outlined,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ), // myIcon is a 48px-wide widget.
                          ),
                          labelText: 'Código',
                          labelStyle: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          suffixStyle: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 2.2),
                              borderRadius: BorderRadius.circular(radiusFocus)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: (loginBtn && codeSession == '')
                                      ? Colors.red
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  width: 2.2),
                              borderRadius:
                                  BorderRadius.circular(radiusNormal)),
                        ),
                        style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 20),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu código';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          codeSession = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 5),
                      child: TextFormField(
                        controller: widget.controllerPassword,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 12.0),
                            child: Icon(Icons.password,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor), // myIcon is a 48px-wide widget.
                          ),
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          suffixStyle: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.2),
                              borderRadius: BorderRadius.circular(radiusFocus)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: (loginBtn && email == '')
                                      ? Colors.red
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  width: 2.2),
                              borderRadius:
                                  BorderRadius.circular(radiusNormal)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obsTextConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            onPressed: () {
                              setState(() {
                                obsTextConfirm = !obsTextConfirm;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 20),
                        obscureText: !obsTextConfirm,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30.0),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(radiusBtn))),
                        onPressed: () {
                          final authState =
                              Provider.of<AuthState>(context, listen: false);
                          authState.setLoginBtn(true); // Cambia el estado

                          if (authState.loginBtn &&
                              codeSession != '' &&
                              password != '') {
                            signInUser(context, codeSession, password);
                            authState.setLoginBtn(false);
                          }
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.lexend(
                              fontSize: 25,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ingresar como Administrador',
                  style: GoogleFonts.roboto(
                    fontSize: 19,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
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

final List<String> professions = [
  'Ingeniero',
  'Doctor',
  'Profesor',
  'Arquitecto',
  'Abogado',
  'Diseñador',
  'Desarrollador',
  'Mecánico',
];

String selectedDepartamento = '';
final List<String> departamentos = [
  'Amazonas',
  'Antioquia',
  'Arauca',
  'Atlántico',
  'Bolívar',
  'Boyacá',
  'Caldas',
  'Caquetá',
  'Casanare',
  'Cauca',
  'Cesar',
  'Chocó',
  'Córdoba',
  'Cundinamarca',
  'Guainía',
  'Guaviare',
  'Huila',
  'La Guajira',
  'Magdalena',
  'Meta',
  'Nariño',
  'Norte de Santander',
  'Putumayo',
  'Quindío',
  'Risaralda',
  'San Andrés, Providencia y Santa Catalina',
  'Santander',
  'Sucre',
  'Tolima',
  'Valle del Cauca',
  'Vaupés',
  'Vichada',
];

List<Map<String, dynamic>> questionsForm = [
  {
    'question': '¿Cuál es su estado civil?',
    'categoryValue': 'Estado civil',
    'options': [
      'Soltero (a)',
      'Casado (a)',
      'Union libre',
      'Separado (a)',
      'Divorciado (a)',
      'Viudo (a)',
    ],
    'iconSection': Icons.bed_outlined,
    'storedVar': selectedMaritalStatus
  },
  {
    'question': '¿Cuál es su nivel de estudios?',
    'categoryValue': 'Nivel de estudios',
    'options': [
      'Primaria incompleta',
      'Primaria completa',
      'Bachillerato incompleto',
      'Bachillerato completo',
      'Técnico / tecnológico incompleto',
      'Técnico / tecnológico completo',
      'Profesional incompleto',
      'Profesional completo',
      'Carrera militar / policía',
      'Post-grado incompleto',
      'Post-grado completo'
    ],
    'iconSection': Icons.school_outlined,
    'storedVar': selectedScholarityLevel
  },
  // {
  //   'question': '¿Cuál es su tipo de vivienda?',
  //   'categoryValue': 'Tipo de vivienda',
  //   'options': ['Propia', 'Alquilada', 'Familiar', 'Otra'],
  //   'iconSection': Icons.home_outlined,
  //   'storedVar': typeHome
  // },
  // {
  //   'question': '¿Cuál es su estrato socioeconómico?',
  //   'categoryValue': 'Estrato social',
  //   'options': ['0', '1', '2', '3', '4', '5', '6', 'Rural', 'No sé'],
  //   'iconSection': Icons.insert_chart_outlined_outlined,
  //   'storedVar': statusResidence
  // },
  {
    'question': '¿Cuál es su tipo de sangre?',
    'categoryValue': 'Tipo de sangre',
    'options': ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'],
    'iconSection': Icons.bloodtype_outlined,
    'storedVar': bloodType
  },
  {
    'question': '¿Cuánto tiempo ha estado en esta empresa?',
    'categoryValue': 'Tiempo en la empresa',
    'options': ['Menos de un año', 'Mas de un año'],
    'iconSection': Icons.work_history_outlined,
    // 'storedVar': timeWorking
  },
  {
    'question': '¿Qué tipo de cargo tiene en la empresa?',
    'categoryValue': 'Tipo de cargo',
    'options': [
      'Jefatura',
      'Profesional',
      'Analista',
      'Técnico',
      'Tecnólogo',
      'Auxiliar',
      'Asistente administrativo',
      'Asistente técnico',
      'Operario',
      'Operador',
      'Ayudante',
      'Servicios generales',
    ],
    'iconSection': Icons.co_present_outlined,
    // 'storedVar': currentRole
  },
  {
    'question': '¿Qué tipo de contrato tiene en la empresa?',
    'categoryValue': 'Tipo de contrato',
    'options': [
      'Temporal de menos de 1 años',
      'Temporal de 1 año o mas',
      'Término indefinido',
      'Cooperado',
      'Prestación de servicios',
      'No sé'
    ],
    'iconSection': Icons.monetization_on_outlined,
    // 'storedVar': contractType
  },
];

class DemographicProfileWorker extends StatefulWidget {
  const DemographicProfileWorker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DemographicProfileWorkerState createState() =>
      _DemographicProfileWorkerState();
}

class _DemographicProfileWorkerState extends State<DemographicProfileWorker> {
  final PageController _pageController =
      PageController(); // Controlador para el PageView
  int _currentPage = 0; // Índice de la página actual

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent));
    });

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Perfil Demográfico'),
        // ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Esquinas redondeadas
          ),
          splashColor: const Color.fromRGBO(155, 100, 255, 1.0),
          hoverElevation: 5,
          elevation: 0,
          onPressed: () {
            nextPage = true;
            if (name.isNotEmpty &&
                surname.isNotEmpty &&
                phoneNumber.isNotEmpty &&
                email.isNotEmpty &&
                selectedGender!.isNotEmpty &&
                _dateController.text.isNotEmpty &&
                _currentPage == 0) {
              if (_currentPage < 4) {
                nextPage = false;
                // Cambia este valor según el número de páginas
                _pageController.animateToPage(
                  _currentPage + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
            if (cedula.isNotEmpty &&
                _dateControllerCedula.text.isNotEmpty &&
                departamentoCedula.isNotEmpty &&
                ciudadCedula.isNotEmpty &&
                _currentPage == 1) {
              if (_currentPage < 4) {
                nextPage = false;
                // Cambia este valor según el número de páginas
                _pageController.animateToPage(
                  _currentPage + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
            if (selectedScholarityLevel.isNotEmpty &&
                occupation.isNotEmpty &&
                selectedMaritalStatus.isNotEmpty &&
                numberOfChildren.isNotEmpty &&
                peopleEconomlyDepend.isNotEmpty &&
                _currentPage == 2) {
              if (_currentPage < 4) {
                nextPage = false;
                // Cambia este valor según el número de páginas
                _pageController.animateToPage(
                  _currentPage + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
            if (stateOfResidence.isNotEmpty &&
                cityOfResidence.isNotEmpty &&
                barrioOfResidence.isNotEmpty &&
                addressOfResidence.isNotEmpty &&
                _currentPage == 3) {
              if (_currentPage < 4) {
                nextPage = false;
                // Cambia este valor según el número de páginas
                _pageController.animateToPage(
                  _currentPage + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
            if (bloodType.isNotEmpty &&
                eps.isNotEmpty &&
                arl.isNotEmpty &&
                pensionFondus.isNotEmpty &&
                _currentPage == 4) {
              saveDemographicProfileOnMongo(context);
            }

            setState(() {});
          },
          backgroundColor: const Color.fromRGBO(10, 120, 255, 1.0),
          child: const Icon(Icons.navigate_next_outlined),
        ),
        body: Center(
            child: Container(
          width: screenWidth > 720 ? screenWidth * 0.6 : screenWidth * 0.98,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                  child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  RegisterQuestions(),
                  PersonalQuestions(),
                  PersonalQuestions2(),
                  ResidenceQuestions(),
                  // LaboralQuestions(),
                  HealthQuestions(),
                ],
              )),
              // Indicador de puntos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? const Color.fromRGBO(10, 100, 255, 1.0)
                          : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10), // Espaciado debajo de los puntos
            ],
          ),
        )));
  }
}

class RegisterQuestions extends StatefulWidget {
  const RegisterQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterQuestions createState() => _RegisterQuestions();
}

class _RegisterQuestions extends State<RegisterQuestions> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ??
          DateTime.now().subtract(const Duration(days: 18 * 365)),
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

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                // Registro de usuario
                width: screenWidth,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Form(
                  key: _formKey0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese su nombre',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Icon(
                                      Icons.text_format,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  counterStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  labelText: 'Nombre',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: (nextPage && name.isEmpty)
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      width: 0.75,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su nombre';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese sus apellidos',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Icon(
                                      Icons.text_fields,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  counterStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  labelText: 'Apellidos',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: (nextPage && surname.isEmpty)
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      width: 0.75,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese sus apellidos';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    surname = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese su número de celular',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              TextFormField(
                                keyboardType: TextInputType
                                    .number, // Activa el teclado numérico
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Permite solo números
                                ],
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Icon(
                                      Icons.numbers,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  counterStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  labelText: 'Número de celular',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: (nextPage && phoneNumber.isEmpty)
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      width: 0.75,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su celular';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    phoneNumber = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese su correo electrónico',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Icon(
                                      Icons.email_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  counterStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  labelText: 'Correo electrónico',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: (nextPage && email.isEmpty)
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      width: 0.75,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese su correo electrónico';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese su sexo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              DropdownButtonFormField<String>(
                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                dropdownColor: Theme.of(context).primaryColor,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                borderRadius: BorderRadius.circular(40),
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 12.0),
                                      child: Icon(Icons.wc_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary), // myIcon is a 48px-wide widget.
                                    ),
                                    labelText: 'Sexo',
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular(radiusFocus),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: (nextPage &&
                                                    ![
                                                      'Masculino',
                                                      'Femenino',
                                                    ].contains(selectedGender))
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75),
                                        borderRadius: BorderRadius.circular(
                                            radiusNormal))),
                                value: selectedGender,
                                items: <String>['Masculino', 'Femenino', 'Otro']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese su fecha de nacimiento',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 12.0),
                                      child: Icon(Icons.date_range_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary), // myIcon is a 48px-wide widget.
                                    ),
                                    labelText: 'Fecha de nacimiento',
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular(radiusFocus),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: (nextPage &&
                                                    selectedDate == null)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75),
                                        borderRadius: BorderRadius.circular(
                                            radiusNormal))),
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor selecciona tu fecha de nacimiento';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class PersonalQuestions extends StatefulWidget {
  const PersonalQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalQuestions createState() => _PersonalQuestions();
}

class _PersonalQuestions extends State<PersonalQuestions> {
  Future<void> _selectDateCedula(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateCedula ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDateCedula) {
      setState(() {
        selectedDateCedula = picked;
        _dateControllerCedula.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                // Registro de usuario
                width: screenWidth,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //   margin: marginCustom,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           '¿Cuál es su departamento de nacimiento?',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             color:
                      //                 Theme.of(context).colorScheme.secondary,
                      //           ),
                      //         ),
                      //         const SizedBox(height: 3),
                      //         Autocomplete<String>(
                      //           optionsBuilder:
                      //               (TextEditingValue textEditingValue) {
                      //             if (textEditingValue.text.isEmpty) {
                      //               return const Iterable<String>.empty();
                      //             }
                      //             return departamentos
                      //                 .where((String profession) {
                      //               return profession.toLowerCase().contains(
                      //                   textEditingValue.text.toLowerCase());
                      //             });
                      //           },
                      //           onSelected: (String selection) {
                      //             setState(() {
                      //               selectedProfession = selection;
                      //             });
                      //           },
                      //           fieldViewBuilder: (BuildContext context,
                      //               TextEditingController textEditingController,
                      //               FocusNode focusNode,
                      //               VoidCallback onFieldSubmitted) {
                      //             return TextFormField(
                      //               controller: textEditingController,
                      //               focusNode: focusNode,
                      //               decoration: InputDecoration(
                      //                 prefixIcon: Padding(
                      //                   padding:
                      //                       const EdgeInsetsDirectional.only(
                      //                           start: 12.0),
                      //                   child: Icon(
                      //                     Icons.location_on_outlined,
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary,
                      //                   ),
                      //                 ),
                      //                 labelText: 'Departamento de nacimiento',
                      //                 labelStyle: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary),
                      //                 focusedBorder: OutlineInputBorder(
                      //                   borderSide: const BorderSide(
                      //                       color: Colors.blue, width: 1.5),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusFocus),
                      //                 ),
                      //                 enabledBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                     color: (nextPage &&
                      //                             (occupation).isEmpty)
                      //                         ? Colors.red
                      //                         : Theme.of(context)
                      //                             .colorScheme
                      //                             .secondary,
                      //                     width: 0.75,
                      //                   ),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusNormal),
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //     margin: marginCustom,
                      //     child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               '¿Cuál es su ciudad/municipio de nacimiento?',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 color: Theme.of(context)
                      //                     .colorScheme
                      //                     .secondary,
                      //               ),
                      //             ),
                      //             spaceSizedBox,
                      //             TextFormField(
                      //               decoration: InputDecoration(
                      //                 prefixIcon: Padding(
                      //                   padding:
                      //                       const EdgeInsetsDirectional.only(
                      //                           start: 12.0),
                      //                   child: Icon(
                      //                     Icons.location_city_outlined,
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary,
                      //                   ),
                      //                 ),
                      //                 counterStyle: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .primaryColorDark),
                      //                 labelText:
                      //                     'Ciudad/municipio de nacimiento',
                      //                 labelStyle: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary),
                      //                 focusedBorder: OutlineInputBorder(
                      //                   borderSide: const BorderSide(
                      //                       color: Colors.blue, width: 1.5),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusFocus),
                      //                 ),
                      //                 enabledBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                     color: (nextPage &&
                      //                             (occupation).isEmpty)
                      //                         ? Colors.red
                      //                         : Theme.of(context)
                      //                             .colorScheme
                      //                             .secondary,
                      //                     width: 0.75,
                      //                   ),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusNormal),
                      //                 ),
                      //               ),
                      //               style: TextStyle(
                      //                   color: Theme.of(context)
                      //                       .colorScheme
                      //                       .secondary),
                      //               validator: (value) {
                      //                 if (value == null || value.isEmpty) {
                      //                   return 'Por favor ingresa tu ciudad de nacimiento';
                      //                 }
                      //                 return null;
                      //               },
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   occupation = value;
                      //                 });
                      //               },
                      //             ),
                      //           ],
                      //         ))),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese su cédula de ciudadanía',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              TextFormField(
                                keyboardType: TextInputType
                                    .number, // Activa el teclado numérico
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Permite solo números
                                ],
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Icon(
                                      Icons.contact_emergency_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  counterStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  labelText: 'Número de cédula de ciudadanía',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: (nextPage && cedula.isEmpty)
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      width: 0.75,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresu número de cédula';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    cedula = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha de expedición',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    controller: _dateControllerCedula,
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(Icons.date_range_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary), // myIcon is a 48px-wide widget.
                                        ),
                                        labelText: 'Fecha de expedición',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: (nextPage &&
                                                        selectedDateCedula ==
                                                            null)
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                width: 0.75),
                                            borderRadius: BorderRadius.circular(
                                                radiusNormal))),
                                    readOnly: true,
                                    onTap: () => _selectDateCedula(context),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor selecciona tu fecha de expedición';
                                      }
                                      return null;
                                    },
                                  ),
                                ])),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese el departamento de expedición',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return departamentos
                                      .where((String profession) {
                                    return profession.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (String selection) {
                                  setState(() {
                                    departamentoCedula = selection;
                                  });
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      labelText: 'Departamento de expedición',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (nextPage &&
                                                  departamentoCedula.isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ingrese ciudad/municipio de expedición',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.location_city_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText:
                                          'Ciudad/municipio de expedición',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              (nextPage && ciudadCedula.isEmpty)
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa tu ciudad de trabajo';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        ciudadCedula = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class PersonalQuestions2 extends StatefulWidget {
  const PersonalQuestions2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalQuestions2 createState() => _PersonalQuestions2();
}

class _PersonalQuestions2 extends State<PersonalQuestions2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    // Registro de usuario
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: const BoxDecoration(color: Colors.transparent
                        // gradient: LinearGradient(
                        //   colors: [
                        //     Colors.pink.withOpacity(0.25),
                        //     Colors.purple.withOpacity(0.25),
                        //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                        //     Colors.blue.withOpacity(0.25),
                        //   ],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                        ),
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...[
                            1,
                          ].expand((nc) {
                            List<Widget> widgets = [];

                            // Validar y configurar el valor inicial
                            String? initialValue =
                                questionsForm[nc]['storedVar'];
                            if (!questionsForm[nc]['options']
                                .contains(initialValue)) {
                              initialValue =
                                  null; // Si el valor no es válido, inicializa con null
                            }

                            // Agregar el DropdownButtonFormField
                            widgets.add(
                              Container(
                                margin: marginCustom,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            questionsForm[nc]['question'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          spaceSizedBox,
                                          DropdownButtonFormField<String>(
                                            icon: const Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                            dropdownColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            decoration: InputDecoration(
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(start: 12.0),
                                                child: Icon(
                                                  questionsForm[nc]
                                                      ['iconSection'],
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              labelText: questionsForm[nc]
                                                  ['categoryValue'],
                                              labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusFocus),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: (nextPage &&
                                                          !questionsForm[nc]
                                                                  ['options']
                                                              .contains(
                                                                  questionsForm[
                                                                          nc][
                                                                      'storedVar']))
                                                      ? Colors.red
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  width: 0.75,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusNormal),
                                              ),
                                            ),
                                            value: initialValue,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            items: questionsForm[nc]['options']
                                                .map<DropdownMenuItem<String>>(
                                                  (String value) =>
                                                      DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedScholarityLevel =
                                                    newValue!;
                                                questionsForm[nc]['storedVar'] =
                                                    newValue;
                                              });
                                            },
                                            iconEnabledColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            validator: (value) => value == null
                                                ? 'Por favor selecciona una opción'
                                                : null,
                                          ),
                                        ])),
                              ),
                            );

                            // Agregar el TextFormField si es nc == 2
                            if (nc == 1) {
                              widgets.add(
                                Container(
                                    margin: marginCustom,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '¿Cuál es su ocupación o profesión?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              spaceSizedBox,
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .only(start: 12.0),
                                                    child: Icon(
                                                      Icons.cases_outlined,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                  counterStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                                  labelText:
                                                      'Ocupación o profesión',
                                                  labelStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue,
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            radiusFocus),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: (nextPage &&
                                                              (occupation)
                                                                  .isEmpty)
                                                          ? Colors.red
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      width: 0.75,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            radiusNormal),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingresa tu ocupación o profesión';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    occupation = value;
                                                  });
                                                },
                                              ),
                                            ])) ////////
                                    ),
                              );
                            }
                            return widgets;
                          }),
                          ...[0].expand((nc) {
                            List<Widget> widgets = [];

                            // Validar y configurar el valor inicial
                            String? initialValue =
                                questionsForm[nc]['storedVar'];
                            if (!questionsForm[nc]['options']
                                .contains(initialValue)) {
                              initialValue =
                                  null; // Si el valor no es válido, inicializa con null
                            }

                            // Agregar el DropdownButtonFormField
                            widgets.add(
                              Container(
                                  margin: marginCustom,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              questionsForm[nc]['question'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            spaceSizedBox,
                                            DropdownButtonFormField<String>(
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_outlined),
                                              dropdownColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 12.0),
                                                  child: Icon(
                                                    questionsForm[nc]
                                                        ['iconSection'],
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                                labelText: questionsForm[nc]
                                                    ['categoryValue'],
                                                labelStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusFocus),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: (nextPage &&
                                                            !questionsForm[nc]
                                                                    ['options']
                                                                .contains(
                                                                    questionsForm[
                                                                            nc][
                                                                        'storedVar']))
                                                        ? Colors.red
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    width: 0.75,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusNormal),
                                                ),
                                              ),
                                              value: initialValue,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              items: questionsForm[nc]
                                                      ['options']
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedMaritalStatus =
                                                      newValue!;
                                                  questionsForm[nc]
                                                      ['storedVar'] = newValue;
                                                });
                                              },
                                              iconEnabledColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Por favor selecciona una opción'
                                                  : null,
                                            ),
                                          ]))),
                            );

                            // Agregar el TextFormField si es nc == 2

                            return widgets;
                          }),
                          Container(
                            margin: marginCustom,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿Cuántos hijos tiene?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    keyboardType: TextInputType
                                        .number, // Activa el teclado numérico
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Permite solo números
                                    ],
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.child_care_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'Cantidad de hijos',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (nextPage &&
                                                  (numberOfChildren).isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa la cantidad de hijos que tiene';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        numberOfChildren = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: marginCustom,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿Cuántas personas dependen económicamente de usted (aunque vivan en otro lugar)?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    keyboardType: TextInputType
                                        .number, // Activa el teclado numérico
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Permite solo números
                                    ],
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.people_alt_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText:
                                          'Personas que dependen económicamente de usted',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (nextPage &&
                                                  (peopleEconomlyDepend)
                                                      .isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa la cantidad de personas que dependen de usted';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        peopleEconomlyDepend = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class ResidenceQuestions extends StatefulWidget {
  const ResidenceQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResidenceQuestions createState() => _ResidenceQuestions();
}

class _ResidenceQuestions extends State<ResidenceQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  // Registro de usuario
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(color: Colors.transparent
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.pink.withOpacity(0.25),
                      //     Colors.purple.withOpacity(0.25),
                      //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                      //     Colors.blue.withOpacity(0.25),
                      //   ],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                      ),
                  child: Form(
                    key: _formKey3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: marginCustom,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¿Cuál es su departamento de residencia?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                spaceSizedBox,
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    return departamentos
                                        .where((String profession) {
                                      return profession.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  onSelected: (String selection) {
                                    setState(() {
                                      stateOfResidence = selection;
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        labelText: 'Departamento de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (nextPage &&
                                                    stateOfResidence.isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            margin: marginCustom,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Cuál es su ciudad/municipio de residencia?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.location_city_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        counterStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        labelText:
                                            'Ciudad/Municipio de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (nextPage &&
                                                    cityOfResidence.isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu ciudad de residencia';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          cityOfResidence = value;
                                        });
                                      },
                                    ),
                                  ],
                                ))),
                        Container(
                            margin: marginCustom,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Cuál es su barrio/localidad de residencia?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.home_work_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        counterStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        labelText:
                                            'Barrio/localidad de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (nextPage &&
                                                    barrioOfResidence.isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingrese su barrio de residencia';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          barrioOfResidence = value;
                                        });
                                      },
                                    ),
                                  ],
                                ))),
                        Container(
                            margin: marginCustom,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Cuál es su dirección de residencia?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.near_me_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        counterStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        labelText: 'Dirección de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (nextPage &&
                                                    addressOfResidence.isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingrese su dirección';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          addressOfResidence = value;
                                        });
                                      },
                                    ),
                                  ],
                                ))),
                        // ...[2, 3].expand((nc) {
                        //   List<Widget> widgets = [];

                        //   // Validar y configurar el valor inicial
                        //   String? initialValue = questionsForm[nc]['storedVar'];
                        //   if (!questionsForm[nc]['options']
                        //       .contains(initialValue)) {
                        //     initialValue =
                        //         null; // Si el valor no es válido, inicializa con null
                        //   }

                        //   // Agregar el DropdownButtonFormField
                        //   widgets.add(
                        //     Container(
                        //         margin: marginCustom,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 questionsForm[nc]['question'] ??
                        //                     'Pregunta no disponible',
                        //                 style: TextStyle(
                        //                   fontSize: 16,
                        //                   color: Theme.of(context)
                        //                       .colorScheme
                        //                       .secondary,
                        //                 ),
                        //               ),
                        //               DropdownButtonFormField<String>(
                        //                 icon: const Icon(
                        //                     Icons.keyboard_arrow_down_outlined),
                        //                 dropdownColor: Theme.of(context)
                        //                     .scaffoldBackgroundColor,
                        //                 decoration: InputDecoration(
                        //                   prefixIcon: Padding(
                        //                     padding: const EdgeInsetsDirectional
                        //                         .only(start: 12.0),
                        //                     child: Icon(
                        //                       questionsForm[nc]['iconSection'],
                        //                       color: Theme.of(context)
                        //                           .colorScheme
                        //                           .secondary,
                        //                     ),
                        //                   ),
                        //                   labelText: questionsForm[nc]
                        //                       ['categoryValue'],
                        //                   labelStyle: TextStyle(
                        //                       color: Theme.of(context)
                        //                           .colorScheme
                        //                           .secondary),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderSide: const BorderSide(
                        //                         color: Colors.blue, width: 1.5),
                        //                     borderRadius: BorderRadius.circular(
                        //                         radiusFocus),
                        //                   ),
                        //                   enabledBorder: OutlineInputBorder(
                        //                     borderSide: BorderSide(
                        //                       color: (nextPage &&
                        //                               !questionsForm[nc]
                        //                                       ['options']
                        //                                   .contains(
                        //                                       questionsForm[nc][
                        //                                           'storedVar']))
                        //                           ? Colors.red
                        //                           : Theme.of(context)
                        //                               .colorScheme
                        //                               .secondary,
                        //                       width: 0.75,
                        //                     ),
                        //                     borderRadius: BorderRadius.circular(
                        //                         radiusNormal),
                        //                   ),
                        //                 ),
                        //                 value: initialValue,
                        //                 style: TextStyle(
                        //                     color: Theme.of(context)
                        //                         .colorScheme
                        //                         .secondary),
                        //                 items: questionsForm[nc]['options']
                        //                     .map<DropdownMenuItem<String>>(
                        //                       (String value) =>
                        //                           DropdownMenuItem<String>(
                        //                         value: value,
                        //                         child: Text(
                        //                           value,
                        //                           style: TextStyle(
                        //                               color: Theme.of(context)
                        //                                   .colorScheme
                        //                                   .secondary),
                        //                         ),
                        //                       ),
                        //                     )
                        //                     .toList(),
                        //                 onChanged: (newValue) {
                        //                   setState(() {
                        //                     questionsForm[nc]['storedVar'] =
                        //                         newValue!;
                        //                   });
                        //                 },
                        //                 iconEnabledColor: Theme.of(context)
                        //                     .colorScheme
                        //                     .secondary,
                        //                 validator: (value) => value == null
                        //                     ? 'Por favor selecciona una opción'
                        //                     : null,
                        //               ),
                        //             ],
                        //           ),
                        //         )),
                        //   );
                        //   // Agregar el TextFormField si es nc == 2
                        //   if (nc == 1) {
                        //     widgets.add(
                        //       Container(
                        //         margin: marginCustom,
                        //         child: TextFormField(
                        //           decoration: InputDecoration(
                        //             prefixIcon: Padding(
                        //               padding: const EdgeInsetsDirectional.only(
                        //                   start: 12.0),
                        //               child: Icon(
                        //                 Icons.cases_outlined,
                        //                 color: Theme.of(context)
                        //                     .colorScheme
                        //                     .secondary,
                        //               ),
                        //             ),
                        //             counterStyle: TextStyle(
                        //                 color:
                        //                     Theme.of(context).primaryColorDark),
                        //             labelText:
                        //                 '¿Cuál es su ocupación o profesión?',
                        //             labelStyle: TextStyle(
                        //                 color: Theme.of(context)
                        //                     .colorScheme
                        //                     .secondary),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderSide: const BorderSide(
                        //                   color: Colors.blue, width: 1.5),
                        //               borderRadius:
                        //                   BorderRadius.circular(radiusFocus),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: (nextPage &&
                        //                         (occupation).isEmpty)
                        //                     ? Colors.red
                        //                     : Theme.of(context)
                        //                         .colorScheme
                        //                         .secondary,
                        //                 width: 0.75,
                        //               ),
                        //               borderRadius:
                        //                   BorderRadius.circular(radiusNormal),
                        //             ),
                        //           ),
                        //           style: TextStyle(
                        //               color: Theme.of(context)
                        //                   .colorScheme
                        //                   .secondary),
                        //           validator: (value) {
                        //             if (value == null || value.isEmpty) {
                        //               return 'Por favor ingresa tu ocupación o profesión';
                        //             }
                        //             return null;
                        //           },
                        //           onChanged: (value) {
                        //             setState(() {
                        //               occupation = value;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     );
                        //   }

                        //   return widgets;
                        // }),
                      ],
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}

class HealthQuestions extends StatefulWidget {
  const HealthQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HealthQuestions createState() => _HealthQuestions();
}

class _HealthQuestions extends State<HealthQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                // Registro de usuario
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(color: Colors.white
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Colors.pink.withOpacity(0.25),
                    //     Colors.purple.withOpacity(0.25),
                    //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                    //     Colors.blue.withOpacity(0.25),
                    //   ],wav
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    ),
                child: Form(
                  key: _formKey4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...[2].expand((nc) {
                        List<Widget> widgets = [];

                        // Validar y configurar el valor inicial
                        String? initialValue = questionsForm[nc]['storedVar'];
                        if (!questionsForm[nc]['options']
                            .contains(initialValue)) {
                          initialValue =
                              null; // Si el valor no es válido, inicializa con null
                        }

                        // Agregar el DropdownButtonFormField
                        widgets.add(
                          Container(
                              margin: marginCustom,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          questionsForm[nc]['question'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        spaceSizedBox,
                                        DropdownButtonFormField<String>(
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                          dropdownColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 12.0),
                                              child: Icon(
                                                questionsForm[nc]
                                                    ['iconSection'],
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            labelText: questionsForm[nc]
                                                ['categoryValue'],
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusFocus),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: (nextPage &&
                                                        !questionsForm[nc]
                                                                ['options']
                                                            .contains(
                                                                questionsForm[
                                                                        nc][
                                                                    'storedVar']))
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                width: 0.75,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusNormal),
                                            ),
                                          ),
                                          value: initialValue,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          items: questionsForm[nc]['options']
                                              .map<DropdownMenuItem<String>>(
                                                (String value) =>
                                                    DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              bloodType = newValue!;
                                              questionsForm[nc]['storedVar'] =
                                                  newValue;
                                            });
                                          },
                                          iconEnabledColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          validator: (value) => value == null
                                              ? 'Por favor selecciona una opción'
                                              : null,
                                        ),
                                      ]))),
                        );

                        // Agregar el TextFormField si es nc == 2

                        return widgets;
                      }),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿A qué EPS está afiliado?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.local_hospital_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'EPS',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (nextPage && eps.isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su EPS';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        eps = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿A qué ARL se encuentra vinculado?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.lock_person_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'ARL',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (nextPage && arl.isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su ARL';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        arl = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿A qué fondo de pensionas está afiliado?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.card_travel_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'Fondo de pensiones',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (nextPage &&
                                                  pensionFondus.isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su fondo de pensiones';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        pensionFondus = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
