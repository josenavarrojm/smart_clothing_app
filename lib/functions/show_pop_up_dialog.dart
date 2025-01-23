import 'package:flutter/material.dart';

/// Muestra un diálogo emergente con un título, mensaje y un botón para cerrar.
///
/// [context] es el contexto del widget.
/// [title] es el título del diálogo.
/// [message] es el mensaje mostrado en el cuerpo del diálogo.
///
/// Retorna un `Future<void>` que completa cuando el diálogo se cierra.
Future<void> showPopUpNotification(
  BuildContext context,
  String title,
  String message,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Aceptar"),
          ),
        ],
      );
    },
  );
}
