import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

/// Muestra un toast con un mensaje personalizado.
///
/// [message] es el texto que aparecerá en el toast.
/// [gravity] define la posición del toast (por defecto, abajo).
/// [backgroundColor] define el color de fondo del toast (por defecto, negro).
/// [textColor] define el color del texto (por defecto, blanco).
/// [durationInSeconds] es la duración del toast en segundos (por defecto, 2 segundos).
/// [fontSize] define el tamaño del texto (por defecto, 16.0).
void showToast({
  required String message,
  ToastGravity gravity = ToastGravity.BOTTOM,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  int durationInSeconds = 2,
  double fontSize = 16.0,
}) {
  if (message.isEmpty) {
    throw ArgumentError("El mensaje no puede estar vacío.");
  }

  Fluttertoast.showToast(
    msg: message,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: durationInSeconds.clamp(
        1, 10), // Limita la duración entre 1 y 10 segundos.
    fontSize: fontSize,
  );
}
