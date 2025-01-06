import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast({
  required String message,
  ToastGravity gravity = ToastGravity.BOTTOM,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  int durationInSeconds = 2,
  double fontSize = 16.0,
}) {
  Fluttertoast.showToast(
    msg: message,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: durationInSeconds,
    fontSize: fontSize,
  );
}
