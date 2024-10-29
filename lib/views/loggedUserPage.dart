import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(50, 50, 200, 1.0),//Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5.0),
          )
        ),
        title: Text("Smart Clothing", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Actualiza el índice al cambiar la página
          });
        },
        children: [
          Center(child: Text('Página 1: Home', style: TextStyle(color: Theme.of(context).primaryColor))),
          Center(child: Text('Página 2: Perfil', style: TextStyle(color: Theme.of(context).primaryColor))),
          Center(child: Text('Página 3: Detalles', style: TextStyle(color: Theme.of(context).primaryColor))),
          Center(child: Text('Página 4: Ajustes', style: TextStyle(color: Theme.of(context).primaryColor))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Color.fromRGBO(25, 25, 90, 1.0),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(15, 15, 90, 1.0),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(25, 25, 100, 1.0),
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(35, 35, 110, 1.0),
            icon: Icon(Icons.abc),
            label: 'Detalles',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(15, 15, 120, 1.0),
            icon: Icon(Icons.accessibility),
            label: 'Ajustes',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}