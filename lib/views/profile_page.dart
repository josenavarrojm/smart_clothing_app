import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:smartclothingproject/views/auth_user.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

// import 'home_user_patient.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String initLetter = '';

  void letterCheck() async {
    for (int i = 65; i <= 90; i++) {
      // Cambiamos la letra actual y actualizamos el estado
      setState(() {
        initLetter = String.fromCharCode(i);
      });

      // Espera 2 segundos antes de continuar al siguiente ciclo
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    });

    bool lightMode = true;

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
                initLetter,
                style: TextStyle(color: Colors.white, fontSize: 80),
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
                  color: const Color.fromRGBO(230, 230, 230, 1),
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
                                color: Colors.white,
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
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.1),
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
                                color: Colors.white,
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
                            Text(
                              'Fecha de nacimiento',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.1),
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
                                color: Colors.white,
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
                            Text(
                              'Correo Electrónico',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.1),
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
                                color: Colors.white,
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
                            Text(
                              'Celular',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.1),
                            )
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
                  color: const Color.fromRGBO(230, 230, 230, 1),
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
                                    color: Colors.white,
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
                                    lightMode
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
                              value: lightMode,
                              onChanged: (value) {
                                setState(() {
                                  lightMode = value;
                                });
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
                  onPressed: () {
                    setState(() {
                      letterCheck();
                    });
                    // saveLastPage('StartPageApp');
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const AuthSwitcher()),
                    //   (Route<dynamic> route) => false,
                    // );
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

// class AnimatedIconContainer extends StatelessWidget {
//   final bool isSelected;
//   final IconData icon;
//   final Duration duration;
//   final List<Color> gradientColors;
//   final EdgeInsets padding;

//   const AnimatedIconContainer({
//     super.key,
//     required this.isSelected,
//     required this.icon,
//     this.duration = const Duration(milliseconds: 200),
//     this.gradientColors = const [Colors.transparent, Colors.transparent],
//     this.padding = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: duration,
//       padding: isSelected
//           ? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0)
//           : padding,
//       decoration: BoxDecoration(
//         borderRadius: isSelected
//             ? BorderRadius.circular(15.0)
//             : BorderRadius.circular(0.0),
//         gradient: isSelected
//             ? LinearGradient(
//                 colors: gradientColors,
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               )
//             : null,
//       ),
//       child: Icon(
//         icon,
//         color: isSelected ? Colors.white : Theme.of(context).primaryColor,
//       ),
//     );
//   }
// }
