import 'package:flutter/material.dart';

void showPopUpNotification(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el dialog
            },
            child: const Text("Aceptar"),
          ),
        ],
      );
    },
  );
}
