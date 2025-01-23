// import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/alerts_notifier.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/ble_connected_state_notifier.dart';
import 'package:smartclothingproject/functions/update_notifiers_sensor_data.dart';
import 'package:smartclothingproject/views/auth_user.dart';
import 'package:smartclothingproject/views/bluetooth_dialog_state.dart';
import 'package:smartclothingproject/views/notification_panel.dart';
import 'package:smartclothingproject/views/profile_page.dart';
import '../handlers/data_base_handler.dart';
import '../models/user_model.dart';

import 'dart:async';

import '../functions/persistance_data.dart';
import 'home_user_worker.dart';

class LoggedUserPage extends StatefulWidget {
  const LoggedUserPage({
    super.key,
  });

  @override
  _LoggedUserPageState createState() => _LoggedUserPageState();
}

class _LoggedUserPageState extends State<LoggedUserPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  List<UserModel> users = [];
  List<Map<String, dynamic>> allSensorData = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Navega a la página seleccionada
  }

  @override
  @override
  void initState() {
    super.initState();
    loadUser();
    loadLastData();

    _pageController.addListener(() {
      final index = _pageController.page!.round();
      if (index != _selectedIndex) {
        setState(() {
          _selectedIndex = index;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final connectionService =
      //     Provider.of<BleConnectionService>(context, listen: false);

      // // if ((!connectionService.isConnected || !connectionService.isSuscripted) &&
      // //     !isDialogVisible &&
      // //     users.isNotEmpty) {
      // //   isDialogVisible = true;
      // //   showDialogIfNeeded(connectionService);
      // // }
    });
  }

  bool isDialogVisible = false;
  void showDialogIfNeeded(BleConnectionService connectionService) async {
    if (mounted && users.isNotEmpty) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BluetoothDialog(
            user: users[0],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const beginOffset = Offset(0.0, 1.0); // Desde arriba hacia abajo
            const endOffset = Offset.zero; // Termina en el centro
            const curve = Curves.easeOut;

            var offsetTween = Tween(begin: beginOffset, end: endOffset)
                .chain(CurveTween(curve: curve));
            var opacityTween = Tween<double>(begin: 0.8, end: 1.0)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(offsetTween),
              child: FadeTransition(
                opacity: animation.drive(opacityTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 350),
        ),
      );
      isDialogVisible =
          false; // Restablecer el estado después de cerrar el diálogo
    } else if (users.isEmpty) {
      print('No users available to show in the dialog.');
    }
  }

  Future<void> loadUser() async {
    // Llama a getAllUsers y guarda los datos en el arreglo users
    users = await DatabaseHandler.instance.getAllUsers();
    // await DatabaseHandler.instance.getAllUsers();

    setState(() {});
  }

  Future<void> loadLastData() async {
    // Llama a getAllUsers y guarda los datos en el arreglo users
    allSensorData = await DatabaseHandler.instance.getAllSensorData();

    if (allSensorData.isNotEmpty) {
      updateNotifiersSensorData(allSensorData.last);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    });

    return Consumer<BlDataNotifier>(builder: (context, blDataNotifier, child) {
      return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: AnimatedContainer(
              height: _selectedIndex == 1 ? 95 : 90,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 600),
              child: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                // backgroundColor: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(0.0))),
                elevation: 0,
                toolbarHeight: _selectedIndex == 1 ? 110 : 90,
                centerTitle: _selectedIndex == 1,
                title: Text(
                    _selectedIndex != 1 ? "Smart Clothing" : "Mi Perfil",
                    style: GoogleFonts.wixMadeforText(
                        color: Theme.of(context).primaryColor,
                        fontSize: _selectedIndex != 1 ? 25 : 30,
                        fontWeight: FontWeight.w700)),
                actions: [
                  if (_selectedIndex != 1) ...[
                    Consumer<BleConnectionService>(
                      builder: (context, connectionService, child) {
                        return IconButton(
                          icon: Icon(
                            ((!connectionService.isConnected &&
                                        connectionService.lostConnection &&
                                        !isDialogVisible) ||
                                    (!connectionService.isConnected))
                                ? Icons.bluetooth_disabled
                                : Icons.bluetooth_connected,
                            size: 28,
                          ),
                          color: ((!connectionService.isConnected &&
                                      connectionService.lostConnection &&
                                      !isDialogVisible) ||
                                  (!connectionService.isConnected))
                              // ? Theme.of(context).colorScheme.tertiary
                              ? Colors.redAccent
                              : Theme.of(context).primaryColor,
                          onPressed: () async {
                            if ((!connectionService.isConnected &&
                                    connectionService.lostConnection &&
                                    !isDialogVisible) ||
                                (!connectionService.isConnected)) {
                              isDialogVisible = true;
                              // Llamar a showDialogIfNeeded solo cuando sea necesario
                              Future.delayed(Duration.zero, () {
                                showDialogIfNeeded(connectionService);
                              });
                            }
                            setState(
                                () {}); // Este setState ahora debería funcionar correctamente.
                          },
                        );
                      },
                    ),
                    _buildNotificationBadge(context)
                  ],
                  if (_selectedIndex != 1)
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        // _selectedIndex != 1 ? Icons.logout : Icons.settings,
                        size: 28,
                      ),
                      color: _selectedIndex == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor,
                      // : Theme.of(context).colorScheme.tertiary,
                      onPressed: () async {
                        if (_selectedIndex != 1) {
                          await DatabaseHandler.instance.deleteUser();
                          saveLastPage('AuthSwitch');
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const AuthSwitcher(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(
                                    -1.0, 0.0); // Comienza desde la izquierda
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
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          body: Consumer<BleConnectionService>(
            builder: (context, connectionService, child) {
              // Mostrar el dialog si la conexión se ha perdido
              // if (!connectionService.isConnected &&
              //     connectionService.lostConnection &&
              //     !isDialogVisible) {
              //   isDialogVisible = true;
              //   // Llamar a showDialogIfNeeded solo cuando sea necesario
              //   Future.delayed(Duration.zero, () {
              //     showDialogIfNeeded(connectionService);
              //   });
              // }
              if (BleConnectionService().isConnected &&
                  BleConnectionService().isSuscripted) isDialogVisible = false;

              // Devolvemos un SizedBox vacío si no hay necesidad de mostrar nada visualmente
              return PageView(
                controller: _pageController,
                allowImplicitScrolling: false,
                children: [
                  users.isNotEmpty
                      ? HomeUserWorker(
                          blDataNotifier: blDataNotifier,
                        )
                      : Center(
                          child: LoadingAnimationWidget.waveDots(
                          color: Colors.blueAccent,
                          size: 50,
                        )),
                  users.isNotEmpty
                      ? ProfilePage(user: users[0])
                      : Center(
                          child: LoadingAnimationWidget.progressiveDots(
                            color: Colors.blueAccent,
                            size: 50,
                          ),
                        ),
                ],
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor, // Color de la sombra
                    // spreadRadius: 0.1, // Cuánto se extiende la sombra
                    // blurRadius: 2, // Qué tan difusa es la sombra
                    offset: const Offset(0, 0), // Ángulo de la sombra (x, y)
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                // backgroundColor: Colors.transparent,
                backgroundColor: Theme.of(context).primaryColor,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 12),
                unselectedLabelStyle: TextStyle(
                    foreground: Paint()
                      ..color = Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.w300,
                    fontSize: 12),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: AnimatedIconContainer(
                      isSelected: _selectedIndex == 0,
                      icon: Icons.home,
                      gradientColors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    label: 'Inicio',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedIconContainer(
                      isSelected: _selectedIndex == 1,
                      icon: Icons.person_rounded,
                      gradientColors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    label: 'Perfil',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          ));
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class AnimatedIconContainer extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final Duration duration;
  final List<Color> gradientColors;
  final EdgeInsets padding;

  const AnimatedIconContainer({
    super.key,
    required this.isSelected,
    required this.icon,
    this.duration = const Duration(milliseconds: 250),
    this.gradientColors = const [Colors.transparent, Colors.transparent],
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      duration: duration,
      padding: isSelected
          ? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0)
          : padding,
      decoration: BoxDecoration(
        borderRadius: isSelected
            ? BorderRadius.circular(25.0)
            : BorderRadius.circular(0.0),
        gradient: isSelected
            ? LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).primaryColorLight,
        size: screenWidth * 0.08,
      ),
    );
  }
}

Widget _buildNotificationBadge(BuildContext context) {
  return Consumer<AlertsNotifier>(builder: (context, alertsNotifier, child) {
    return FutureBuilder<String?>(
      future: getAlerts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mostrar el Badge mientras carga
          return Container(
              margin: const EdgeInsets.only(right: 10),
              child: Badge(
                alignment: Alignment.topRight,
                backgroundColor: Colors.red,
                smallSize: 0.0,
                largeSize: 20.0,
                label: null, // No muestra nada mientras carga
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.notifications_outlined,
                      size: 28, color: Theme.of(context).primaryColor),
                  // size: 30, color: Theme.of(context).colorScheme.tertiary),
                ),
              ));
        }

        // Cuando el valor ya está cargado
        final alertsSaved = snapshot.data ?? '';
        if (alertsNotifier.newAlerts.isEmpty && alertsSaved.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            alertsNotifier.updateNewAlerts(alertsSaved);
          });
        }
        return GestureDetector(
          onTap: () {
            saveAlerts('');
            alertsNotifier.updateNewAlerts('');
            FlutterLocalNotificationsPlugin().cancelAll();
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const NotificationPanel(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const beginOffset =
                      Offset(1.0, 0.0); // Desde arriba hacia abajo
                  const endOffset = Offset.zero; // Termina en el centro
                  const curve = Curves.easeOut;

                  var offsetTween = Tween(begin: beginOffset, end: endOffset)
                      .chain(CurveTween(curve: curve));
                  var opacityTween = Tween<double>(begin: 0.8, end: 1.0)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(offsetTween),
                    child: FadeTransition(
                      opacity: animation.drive(opacityTween),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 250),
                reverseTransitionDuration: const Duration(milliseconds: 250),
              ),
            );
          },
          child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Badge(
                alignment: Alignment.topRight,
                backgroundColor: Colors.red,
                smallSize: 0.0,
                largeSize: 15.0,
                label: alertsNotifier.newAlerts.isEmpty
                    ? null
                    : Text(alertsNotifier.newAlerts),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.notifications_outlined,
                      size: 28, color: Theme.of(context).primaryColor),
                  // size: 28, color: Theme.of(context).colorScheme.tertiary),
                ),
              )),
        );
      },
    );
  });
}
