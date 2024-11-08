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
            // UserProfileAvatar(
            //   avatarUrl: '',
            //   onAvatarTap: () {
            //     print('Avatar Tapped..');
            //   },
            //   // notificationCount: null,
            //   // notificationBubbleTextStyle: const TextStyle(
            //   //   fontSize: 30,
            //   //   color: Colors.white,
            //   //   fontWeight: FontWeight.bold,
            //   // ),
            //   avatarSplashColor: const Color.fromARGB(255, 76, 0, 255),
            //   radius: 80,
            //   isActivityIndicatorSmall: false,
            //   avatarBorderData: AvatarBorderData(
            //     borderColor: Colors.red,
            //     borderWidth: 5.0,
            //   ),
            // ),
            SizedBox(
              width: screenWidth * 0.92,
              height: 400,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50, top: 10),
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 15, bottom: 10),
                        child: Text(
                          'Información General',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
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
                            Icon(
                              Icons.date_range_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Fecha de nacimiento',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
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
                            Icon(
                              Icons.email_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Correo Electrónico',
                              style: TextStyle(
                                  fontSize: 20,
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
                            Icon(
                              Icons.smartphone_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Celular',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
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
              margin: EdgeInsets.only(bottom: 20),
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
