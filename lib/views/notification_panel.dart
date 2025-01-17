import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartclothingproject/functions/show_toast.dart';
import 'package:smartclothingproject/handlers/data_base_handler.dart';
import 'package:smartclothingproject/models/alert_model.dart';

class NotificationPanel extends StatefulWidget {
  const NotificationPanel({super.key});

  @override
  _NotificationPanelState createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  List<AlertModel> alerts = [];

  @override
  void initState() {
    super.initState();
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    try {
      alerts = await DatabaseHandler.instance.getAllAlerts();

      // Ordenar las alertas por fecha y hora: más recientes primero
      alerts.sort((a, b) {
        // Convertir las propiedades en enteros para compararlas
        int yearA = int.parse(a.year);
        int yearB = int.parse(b.year);
        int monthA = int.parse(a.month);
        int monthB = int.parse(b.month);
        int dayA = int.parse(a.day);
        int dayB = int.parse(b.day);
        int hourA = int.parse(a.hour);
        int hourB = int.parse(b.hour);
        int minuteA = int.parse(a.minute);
        int minuteB = int.parse(b.minute);

        // Compara los valores en orden de más reciente a más antiguo
        if (yearA != yearB) return yearB.compareTo(yearA);
        if (monthA != monthB) return monthB.compareTo(monthA);
        if (dayA != dayB) return dayB.compareTo(dayA);
        if (hourA != hourB) return hourB.compareTo(hourA);
        return minuteB.compareTo(minuteA);
      });

      setState(() {});
    } catch (e) {
      showToast(message: 'Error al cargar las alertas: $e');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          toolbarHeight: 110,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Alertas',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              // color: Theme.of(context).primaryColorLight,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarColor: Theme.of(context).primaryColor,
                    systemNavigationBarIconBrightness: Brightness.light,
                  ));
                });
              },
            ),
          ],
        ),
      ),
      body: alerts.isEmpty
          ? Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_rounded,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                Text('No tiene notificaciones nuevas',
                    style: GoogleFonts.lexend(
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey)),
              ],
            ))
          : Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection
                        .horizontal, // Arrastrar hacia la derecha
                    onDismissed: (direction) async {
                      // Llamar a la función para eliminar la alerta de la base de datos
                      await DatabaseHandler.instance
                          .deleteAlert(alerts[index].id!);

                      // Eliminar la alerta de la lista local
                      setState(() {
                        alerts.removeAt(index);
                      });

                      // Mostrar un mensaje o notificación
                      showToast(message: 'Alerta eliminada');
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Theme.of(context).colorScheme.tertiary,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 30,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Theme.of(context).colorScheme.tertiary,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 30,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: ListTile(
                        leading: Text(
                          "${alerts[index].hour}:${int.parse(alerts[index].minute) < 10 ? '0${alerts[index].minute}' : alerts[index].minute}",
                          style: GoogleFonts.lexend(
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        title: Text(
                          alerts[index].title,
                          style: GoogleFonts.lexend(
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          softWrap: false, // Evita el salto de línea
                          overflow: TextOverflow
                              .ellipsis, // Muestra los puntos suspensivos
                          maxLines: 1, // Limita a una línea
                        ),
                        subtitle: Text(
                          alerts[index].description,
                          style: GoogleFonts.lexend(
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColorLight),
                          softWrap: false, // Evita el salto de línea
                          overflow: TextOverflow
                              .ellipsis, // Muestra los puntos suspensivos
                          maxLines: 1, // Limita a una línea
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            size: 30,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () async {
                            // Llamar a la función para eliminar la alerta de la base de datos
                            await DatabaseHandler.instance
                                .deleteAlert(alerts[index].id!);

                            // Eliminar la alerta de la lista local
                            setState(() {
                              alerts.removeAt(index);
                            });

                            // Mostrar un mensaje o notificación
                            showToast(message: 'Alerta eliminada');
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
