import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationPanel extends StatefulWidget {
  @override
  _NotificationPanelState createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  List<String> notifications = [
    "Notification 1",
    "Notification 2",
    "Notification 3",
    "Notification 4",
    "Notification 5",
    "Notification 6",
    "Notification 7",
    "Notification 8",
    "Notification 9",
    "Notification 10",
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
                fontWeight: FontWeight.w700),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.close_rounded,
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
      body: SizedBox(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          // color: Colors.white,
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColorLight,
                ),
                // color: Theme.of(context).primaryColorLight,
                child: ListTile(
                  title: Text(
                    notifications[index],
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
