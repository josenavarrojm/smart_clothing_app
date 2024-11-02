import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ladys_app/views/auth_user.dart';
import 'package:ladys_app/views/bluetooth_ui.dart';

import '../functions/LastPage.dart';
import 'home_user_patient.dart';

class LoggedUserPage extends StatefulWidget {
  const LoggedUserPage({super.key});

  @override
  _LoggedUserPageState createState() => _LoggedUserPageState();
}

class _LoggedUserPageState extends State<LoggedUserPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Navega a la página seleccionada
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context)
            .scaffoldBackgroundColor, //Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(0.0),
        )),
        elevation: 0.5,
        shadowColor: Colors.grey,
        title: Text(
          "Smart Clothing",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.blueAccent,
            onPressed: () {
              saveLastPage('Home');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthSwitcher()),
                (Route<dynamic> route) =>
                    false, // Aquí false indica que todas las vistas anteriores deben eliminarse
              );
            },
          ),
          // Puedes agregar más botones en esta lista si lo deseas
        ],
      ),
      body: PageView(
        controller: _pageController,
        allowImplicitScrolling: false,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Actualiza el índice al cambiar la página
          });
        },
        children: [
          const BlueetoothUI(),
          const HomeUserPatient(),
          Center(
              child: Text('Página 3: Detalles',
                  style: TextStyle(color: Theme.of(context).primaryColor))),
          Center(
              child: Text('Página 4: Ajustes',
                  style: TextStyle(color: Theme.of(context).primaryColor))),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(1, 1, 80, 1.0), width: 1))),
        height: screenHeight * 0.1,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
              fontSize: 14),
          unselectedLabelStyle: TextStyle(
              foreground: Paint()..color = Theme.of(context).primaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 14),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: AnimatedIconContainer(
                isSelected: _selectedIndex == 0,
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
                isSelected: _selectedIndex == 1,
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
                isSelected: _selectedIndex == 2,
                icon: Icons.note_alt,
                gradientColors: const [
                  Color.fromRGBO(100, 120, 120, 0.85),
                  Color.fromRGBO(150, 170, 170, 0.85),
                ],
              ),
              label: 'Recomendaciones',
            ),
            BottomNavigationBarItem(
              icon: AnimatedIconContainer(
                isSelected: _selectedIndex == 3,
                icon: Icons.person,
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
    this.duration = const Duration(milliseconds: 200),
    this.gradientColors = const [Colors.transparent, Colors.transparent],
    this.padding = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3.0),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      padding: isSelected
          ? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0)
          : padding,
      decoration: BoxDecoration(
        borderRadius: isSelected
            ? BorderRadius.circular(15.0)
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
      ),
    );
  }
}
