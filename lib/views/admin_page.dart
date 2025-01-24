import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/persistance_data.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/views/auth_user.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final mongoService = Provider.of<MongoService>(context, listen: false);
    await mongoService.connect();
    users = await mongoService.getDocuments("users");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Usuarios',
          style: GoogleFonts.lexend(
            color: Theme.of(context).primaryColor,
            fontSize: 35,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              // _selectedIndex != 1 ? Icons.logout : Icons.settings,
              size: 28,
            ),
            color: Theme.of(context).primaryColor,
            // : Theme.of(context).colorScheme.tertiary,
            onPressed: () async {
              // await DatabaseHandler.instance.deleteUser();
              saveLastPage('AuthSwitch');
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
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          elevation: 5,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          onPressed: () {
            addUser();
          },
          shape: const CircleBorder(),
          child: Icon(
            Icons.person_add_outlined,
            color: Theme.of(context).primaryColor,
            size: 35,
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: users.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Text(
                          user['Name'][0], // Primera letra del nombre
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        '${user['Name']} ${user['Surname']}',
                        style: GoogleFonts.lexend(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Correo: ${user['Email']}',
                        style: GoogleFonts.lexend(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Lógica al tocar un usuario
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                'Detalles de ${user['Name']} ${user['Surname']}'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Edad: ${user['Age']} años'),
                                Text('Género: ${user['Gender']}'),
                                Text('Correo: ${user['Email']}'),
                                Text(
                                    'Teléfono: ${user['PhoneNumber'] ?? 'No disponible'}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

void addUser() {}
