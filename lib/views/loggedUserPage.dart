import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
import 'package:smartclothingproject/functions/connected_state_notifier.dart';
import 'package:smartclothingproject/views/auth_user.dart';
import 'package:smartclothingproject/views/bluetooth_dialog_state.dart';
import 'package:smartclothingproject/views/bluetooth_ui.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Navega a la página seleccionada
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    _pageController.addListener(() {
      final index = _pageController.page!.round();
      if (index != _selectedIndex) {
        setState(() {
          _selectedIndex = index;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectionService =
          Provider.of<ConnectionService>(context, listen: false);
      if (!connectionService.isSuscripted) {
        showDialogIfNeeded(connectionService);
      }
    });
  }

  bool isDialogVisible = false;
  void showDialogIfNeeded(ConnectionService connectionService) async {
    if (!connectionService.isSuscripted && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return const BluetoothDialog();
        },
      );
    }
  }

  Future<void> loadUser() async {
    // Llama a getAllUsers y guarda los datos en el arreglo users
    users = await DatabaseHandler.instance.getAllUsers();
    // await DatabaseHandler.instance.getAllUsers();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    });

    return Consumer<BlDataNotifier>(builder: (context, blDataNotifier, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AnimatedContainer(
            height: _selectedIndex == 3 ? 110 : 90,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 600),
            child: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(0.0))),
              elevation: 0,
              toolbarHeight: _selectedIndex == 3 ? 110 : 90,
              toolbarOpacity: 0.8,
              centerTitle: _selectedIndex == 3,
              title: Text(
                _selectedIndex != 3 ? "Smart Clothing" : "Mi Perfil",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: _selectedIndex != 3 ? 25 : 30,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                // IconButton(
                //   icon: const Icon(Icons.bluetooth_searching),
                //   color: Colors.blueAccent,
                //   onPressed: () {
                //     if (ConnectionService().lostConnection) {
                //       showDialogIfNeeded(ConnectionService());
                //     }
                //     setState(() {});
                //   },
                // ),
                if (_selectedIndex != 3) ...[
                  Consumer<ConnectionService>(
                    builder: (context, connectionService, child) {
                      return IconButton(
                        icon: Icon(
                          ((!connectionService.isConnected &&
                                      connectionService.lostConnection &&
                                      !isDialogVisible) ||
                                  (!connectionService.isConnected))
                              ? Icons.bluetooth_disabled
                              : Icons.bluetooth_connected,
                        ),
                        color: ((!connectionService.isConnected &&
                                    connectionService.lostConnection &&
                                    !isDialogVisible) ||
                                (!connectionService.isConnected))
                            ? Colors.red
                            : Colors.blueAccent,
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
                  _buildNotificationIcon(_selectedIndex)
                ],
                IconButton(
                  icon:
                      Icon(_selectedIndex != 3 ? Icons.logout : Icons.settings),
                  color: Colors.blueAccent,
                  onPressed: () async {
                    if (_selectedIndex != 3) {
                      await DatabaseHandler.instance.deleteUser();
                      saveLastPage('AuthSwitch');
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AuthSwitcher(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
        body: Consumer<ConnectionService>(
          builder: (context, connectionService, child) {
            // Mostrar el dialog si la conexión se ha perdido
            if (!connectionService.isConnected &&
                connectionService.lostConnection &&
                !isDialogVisible) {
              isDialogVisible = true;
              // Llamar a showDialogIfNeeded solo cuando sea necesario
              Future.delayed(Duration.zero, () {
                showDialogIfNeeded(connectionService);
              });
            }
            if (ConnectionService().isConnected &&
                ConnectionService().isSuscripted) isDialogVisible = false;

            // Devolvemos un SizedBox vacío si no hay necesidad de mostrar nada visualmente
            return PageView(
              controller: _pageController,
              allowImplicitScrolling: false,
              children: [
                HomeUserWorker(blDataNotifier: blDataNotifier),
                BluetoothUI(),
                // Center(
                //   child: Text(
                //     'Página 2: Cachón',
                //     style: TextStyle(color: Theme.of(context).primaryColor),
                //   ),
                // ),
                Center(
                  child: Text(
                    'Página 3: Detalles',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
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
        bottomNavigationBar: Container(
          height: 85,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .primaryColor
                    .withOpacity(0.0), // Color de la sombra
                spreadRadius: 0.1, // Cuánto se extiende la sombra
                blurRadius: 2, // Qué tan difusa es la sombra
                offset: const Offset(0, 0), // Ángulo de la sombra (x, y)
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
                fontSize: 14),
            unselectedLabelStyle: TextStyle(
                foreground: Paint()..color = Theme.of(context).primaryColor,
                fontWeight: FontWeight.w300,
                fontSize: 14),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: AnimatedIconContainer(
                  isSelected: _selectedIndex == 0,
                  icon: Icons.home,
                  gradientColors: const [
                    Color.fromRGBO(100, 120, 120, 0.85),
                    Color.fromRGBO(150, 170, 170, 0.85),
                  ],
                ),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: AnimatedIconContainer(
                  isSelected: _selectedIndex == 1,
                  icon: Icons.bluetooth,
                  gradientColors: const [
                    Color.fromRGBO(100, 120, 120, 0.85),
                    Color.fromRGBO(150, 170, 170, 0.85),
                  ],
                ),
                label: 'Bluetooth',
              ),
              BottomNavigationBarItem(
                icon: AnimatedIconContainer(
                  isSelected: _selectedIndex == 2,
                  icon: Icons.deblur,
                  gradientColors: const [
                    Color.fromRGBO(100, 120, 120, 0.85),
                    Color.fromRGBO(150, 170, 170, 0.85),
                  ],
                ),
                label: 'Detalles',
              ),
              BottomNavigationBarItem(
                icon: AnimatedIconContainer(
                  isSelected: _selectedIndex == 3,
                  icon: Icons.person_rounded,
                  gradientColors: const [
                    Color.fromRGBO(100, 120, 120, 0.85),
                    Color.fromRGBO(150, 170, 170, 0.85),
                  ],
                ),
                label: 'Perfil',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      );
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
        color: isSelected ? Colors.white : Theme.of(context).primaryColor,
        size: screenWidth * 0.09,
      ),
    );
  }
}

Widget _buildNotificationIcon(int selectedIndex) {
  return IconButton(
    icon: Badge(
      alignment: Alignment.topRight,
      backgroundColor: Colors.red,
      smallSize: 10.0,
      largeSize: 20.0,
      label: Text('$selectedIndex'),
      child: const AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 300),
        child: Icon(Icons.notifications),
      ),
    ),
    color: Colors.blueAccent,
    onPressed: () {
      // Acción para el botón
    },
  );
}
