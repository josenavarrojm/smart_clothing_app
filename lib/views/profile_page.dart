import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:smartclothingproject/functions/persistance_data.dart';
import 'package:smartclothingproject/handlers/data_base_handler.dart';
import 'package:smartclothingproject/views/auth_user.dart';
import 'package:provider/provider.dart';
import '../functions/theme_notifier.dart';
import '../models/user_model.dart';

// import 'home_user_patient.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        ));
      }
    });

    return SingleChildScrollView(
        child: Center(
      child: Container(
        width: screenWidth * 0.95,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: 120.0, // Ancho y alto iguales para que sea un círculo
              height: 120.0,
              margin: const EdgeInsets.only(bottom: 20, top: 20),
              decoration: const BoxDecoration(
                color: Colors.blue, // Color de fondo del círculo
                shape: BoxShape.circle, // Forma circular
              ),
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(
                  left: 25,
                  bottom: 0,
                ),
                child: const Text(
                  'Información General',
                  style: TextStyle(
                      color: Colors.grey,
                      // color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                )),
            SizedBox(
              width: screenWidth * 0.92,
              child: Container(
                margin: const EdgeInsets.only(bottom: 15, top: 10),
                padding: const EdgeInsets.only(
                    bottom: 20, top: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  color: themeNotifier.isLightTheme
                      ? const Color.fromRGBO(230, 230, 230, 1)
                      : const Color.fromRGBO(30, 30, 30, 1),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.5), // Color de la sombra
                      spreadRadius: 0.1, // Cuánto se extiende la sombra
                      blurRadius: 0.1, // Qué tan difusa es la sombra
                      offset: const Offset(0, 0), // Ángulo de la sombra (x, y)
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: themeNotifier.isLightTheme
                                    ? Colors.white
                                    : Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5), // Color de la sombra
                                    spreadRadius:
                                        0.1, // Cuánto se extiende la sombra
                                    blurRadius:
                                        0.1, // Qué tan difusa es la sombra
                                    offset: const Offset(
                                        0, 0), // Ángulo de la sombra (x, y)
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                '${user.name} ${user.surname}',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1.1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )),
                    Divider(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.5), // Color del divisor
                      thickness: 0.2, // Grosor del borde
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: themeNotifier.isLightTheme
                                    ? Colors.white
                                    : Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5), // Color de la sombra
                                    spreadRadius:
                                        0.1, // Cuánto se extiende la sombra
                                    blurRadius:
                                        0.1, // Qué tan difusa es la sombra
                                    offset: const Offset(
                                        0, 0), // Ángulo de la sombra (x, y)
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.date_range_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Text(
                              user.birthDate,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.1),
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        )),
                    Divider(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.5), // Color del divisor
                      thickness: 0.2, // Grosor del borde
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: themeNotifier.isLightTheme
                                    ? Colors.white
                                    : Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5), // Color de la sombra
                                    spreadRadius:
                                        0.1, // Cuánto se extiende la sombra
                                    blurRadius:
                                        0.1, // Qué tan difusa es la sombra
                                    offset: const Offset(
                                        0, 0), // Ángulo de la sombra (x, y)
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Text(user.email,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.1),
                                    overflow: TextOverflow.ellipsis))
                          ],
                        )),
                    Divider(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.5), // Color del divisor
                      thickness: 0.2, // Grosor del borde
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: themeNotifier.isLightTheme
                                    ? Colors.white
                                    : Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5), // Color de la sombra
                                    spreadRadius:
                                        0.1, // Cuánto se extiende la sombra
                                    blurRadius:
                                        0.1, // Qué tan difusa es la sombra
                                    offset: const Offset(
                                        0, 0), // Ángulo de la sombra (x, y)
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.smartphone_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                child: Text(user.phoneNumber,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.1),
                                    overflow: TextOverflow.ellipsis))
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(
                  left: 25,
                  bottom: 0,
                ),
                child: const Text(
                  'Preferencias',
                  style: TextStyle(
                      color: Colors.grey,
                      // color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                )),
            SizedBox(
              width: screenWidth * 0.92,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50, top: 10),
                padding: const EdgeInsets.only(
                    bottom: 20, top: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  color: themeNotifier.isLightTheme
                      ? const Color.fromRGBO(230, 230, 230, 1)
                      : const Color.fromRGBO(30, 30, 30, 1),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.5), // Color de la sombra
                      spreadRadius: 0.1, // Cuánto se extiende la sombra
                      blurRadius: 0.1, // Qué tan difusa es la sombra
                      offset: const Offset(0, 0), // Ángulo de la sombra (x, y)
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: themeNotifier.isLightTheme
                                        ? Colors.white
                                        : Colors.black,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(
                                                0.5), // Color de la sombra
                                        spreadRadius:
                                            0.1, // Cuánto se extiende la sombra
                                        blurRadius:
                                            0.1, // Qué tan difusa es la sombra
                                        offset: const Offset(
                                            0, 0), // Ángulo de la sombra (x, y)
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    themeNotifier.isLightTheme
                                        ? Icons.light_mode_outlined
                                        : Icons.dark_mode_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Tema oscuro',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1.1),
                                ),
                              ],
                            ),
                            Switch(
                              activeColor: Colors.blue,
                              activeTrackColor: Colors.black,
                              inactiveTrackColor: Colors.grey,
                              value: !(themeNotifier.isLightTheme),
                              onChanged: (value) {
                                themeNotifier.toggleTheme(!value);
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: screenWidth * 0.92,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // padding: const EdgeInsets.all(1.0),
                      elevation: 0.5,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(22)),
                          side: BorderSide(
                              color: Colors.red.withOpacity(0.5),
                              width: 0.8,
                              style: BorderStyle.solid))),
                  onPressed: () async {
                    await DatabaseHandler.instance.deleteUser();
                    saveLastPage('AuthSwitch');
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
                  child: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}
