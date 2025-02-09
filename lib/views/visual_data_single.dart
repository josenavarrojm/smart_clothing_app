import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartclothingproject/functions/hash_password.dart';
import 'package:smartclothingproject/functions/show_toast.dart';
import 'package:smartclothingproject/handlers/mongo_database.dart';
import 'package:smartclothingproject/views/register_resume_view_siso.dart';

class VisualData extends StatefulWidget {
  const VisualData({super.key});

  @override
  _VisualDataState createState() => _VisualDataState();
}

class _VisualDataState extends State<VisualData> {
  List<Map<String, dynamic>> userListUpdatedReload = [];
  bool registerListUpdate = false;

  @override
  void initState() {
    super.initState();
    loadRegisters();
  }

  List<Map<String, dynamic>> registers = [];
  Future<void> loadRegisters() async {
    try {
      final mongoService = Provider.of<MongoService>(context, listen: false);
      await mongoService.connect();
      final fetchedUsers = await mongoService.getDocuments("data");

      setState(() {
        registers = fetchedUsers;
      });
    } catch (e) {
      print("Error al cargar usuarios: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ));
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Registros',
          style: GoogleFonts.lexend(
            color: Theme.of(context).primaryColor,
            fontSize: 35,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.replay_outlined,
              size: 28,
            ),
            color: Theme.of(context).primaryColor,
            // : Theme.of(context).colorScheme.tertiary,
            onPressed: () async {
              setState(() {
                registerListUpdate =
                    true; // Notifica a la UI que debe mostrar el indicador
              });

              final mongoService =
                  Provider.of<MongoService>(context, listen: false);
              await mongoService.connect();
              final userListUpdated = await mongoService.getDocuments("data");
              userListUpdatedReload = userListUpdated;

              setState(() {
                registers = userListUpdatedReload;
                registerListUpdate = false; // Detén el indicador cuando termine
                showToast(message: 'Lista Actualizada');
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: registerListUpdate
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : registers.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: registers.length,
                    itemBuilder: (context, index) {
                      final item = registers[index];

                      // Convertir timestamp en fecha legible
                      String formattedDate = "Fecha no disponible";
                      if (item["timestamp"] != null) {
                        try {
                          int timestamp = item["timestamp"] is int
                              ? item["timestamp"]
                              : int.tryParse(item["timestamp"].toString()) ?? 0;
                          formattedDate =
                              DateFormat('EEE, MMM d, yyyy - hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(timestamp),
                          );
                        } catch (e) {
                          print("Error al convertir timestamp: $e");
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            "Usuario: ${item["user_id"] ?? "Desconocido"}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("BPM: ${item["bpm"] ?? "N/A"}"),
                              Text(
                                  "Temperatura Corporal: ${item["tempCorp"] ?? "N/A"}°C"),
                              Text(
                                  "Temperatura Ambiente: ${item["tempAmb"] ?? "N/A"}°C"),
                              Text("Humedad: ${item["hum"] ?? "N/A"}%"),
                              Text("Fecha: $formattedDate"),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        RegisterResumeView(
                                  register: item,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const beginOffset = Offset(
                                      1.0, 0.0); // Desde arriba hacia abajo
                                  const endOffset =
                                      Offset.zero; // Termina en el centro
                                  const curve = Curves.easeOut;

                                  var offsetTween =
                                      Tween(begin: beginOffset, end: endOffset)
                                          .chain(CurveTween(curve: curve));
                                  var opacityTween =
                                      Tween<double>(begin: 0.8, end: 1.0)
                                          .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(offsetTween),
                                    child: FadeTransition(
                                      opacity: animation.drive(opacityTween),
                                      child: child,
                                    ),
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 250),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 250),
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

void showAddUserDialog(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false, // Permite que el fondo sea transparente
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: Stack(
            children: [
              // Fondo desenfocado
              BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5.0, sigmaY: 5.0), // Ajusta el nivel de desenfoque
                child: Container(
                  color: Colors.black.withOpacity(
                      0.2), // Color semi-transparente sobre el fondo
                ),
              ),
              // Cuadro de diálogo
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    'Agregar Empleado',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const AddUserForm(),
                ),
              ),
            ],
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut; // Curva de animación suave

        final scaleTween =
            Tween<double>(begin: 0.1, end: 1.0).chain(CurveTween(curve: curve));
        final fadeTween =
            Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(scaleTween), // Escala del zoom
          child: FadeTransition(
            opacity: animation.drive(
                fadeTween), // Efecto de desvanecimiento junto con el zoom
            child: child,
          ),
        );
      },
    ),
  );
}

class AddUserForm extends StatefulWidget {
  const AddUserForm({
    super.key,
  });

  @override
  _AddUserForm createState() => _AddUserForm();
}

class _AddUserForm extends State<AddUserForm> {
  final _codeSessionController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void addUser(
      BuildContext context, String codeSession, String password) async {
    final mongoService = Provider.of<MongoService>(context, listen: false);
    await mongoService.connect();

    // Verificar si ya existe el usuario con el codeSession
    final filter = {"user_id": codeSession};
    final existingUser =
        await mongoService.getDocuments("users", filter: filter);

    if (existingUser.isNotEmpty) {
      showToast(
          message: 'El usuario con codeSession "$codeSession" ya existe.');
    } else {
      // Si no existe, agregar el nuevo usuario
      final passwordHashed = hashPassword(password);
      Map<String, dynamic> data = {
        'user_id': codeSession,
        'Hashpwd': passwordHashed,
      };
      await mongoService.insertDocument(data, 'users');
      showToast(message: 'Agregado exitosamente');
      print('Usuario agregado correctamente: $data');
      Navigator.pop(context); // Cierra el cuadro de diálogo
    }

    await mongoService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _codeSessionController,
          decoration: InputDecoration(
            labelText: 'Código de usuario',
            labelStyle: GoogleFonts.lexend(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), // Bordes redondeados
              borderSide: const BorderSide(
                color: Colors.grey, // Color del borde
                width: 2, // Ancho del borde
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .secondary, // Borde cuando el campo no está enfocado
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.blue, // Borde cuando el campo está enfocado
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white, // Fondo del campo
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: GoogleFonts.lexend(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText; // Cambiar el estado
                });
              },
            ),
          ),
          obscureText: _obscureText, // Mostrar u ocultar texto
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                // Limpia los campos y cierra el cuadro de diálogo
                _codeSessionController.clear();
                _passwordController.clear();
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Cancelar',
                style: GoogleFonts.lexend(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para agregar usuario
                setState(() {
                  final codeSession = _codeSessionController.text;
                  final password = _passwordController.text;
                  addUser(context, codeSession, password);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              child: Text(
                'Agregar',
                style: GoogleFonts.lexend(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
