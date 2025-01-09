import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartclothingproject/functions/show_toast.dart';

class NotificationPanel extends StatefulWidget {
  @override
  _NotificationPanelState createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  List<Map<String, String>> notifications = [
    {
      'title': 'Alerta de oxígeno en sangre',
      'description': 'El nivel de oxígeno en sangre es muy bajo',
      'time': '14:00',
    },
    {
      'title': 'Alerta de ritmo cardíaco',
      'description': 'El ritmo cardíaco es muy bajo',
      'time': '13:00',
    },
    {
      'title': 'Alerta de temperatura',
      'description': 'La temperatura del cuerpo es muy alta',
      'time': '12:00',
    },
  ];

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
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Alertas',
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
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
                color: Theme.of(context).colorScheme.tertiary,
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
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              direction:
                  DismissDirection.horizontal, // Arrastrar hacia la derecha
              onDismissed: (direction) {
                setState(() {
                  notifications.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notificación eliminada'),
                    duration: Duration(seconds: 2),
                  ),
                );
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: ListTile(
                  leading: Text(
                    notifications[index]['time']!,
                    style: GoogleFonts.lexend(
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  title: Text(
                    notifications[index]['title']!,
                    style: GoogleFonts.lexend(
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    // TextStyle(
                    //   color: Theme.of(context).scaffoldBackgroundColor,
                    //   fontSize: 20,
                    //   fontWeight: FontWeight.w600,
                    // ),
                  ),
                  subtitle: Text(
                    '${notifications[index]['description']}',
                    style: GoogleFonts.lexend(
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColorLight),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: () {
                      setState(() {
                        showToast(message: 'Notificación eliminada');
                        notifications.removeAt(index);
                      });
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
