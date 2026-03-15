import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum SnackType { success, error }

Color _getSnackbarColor(SnackType type) {
  switch (type) {
    case SnackType.success:
      return Colors.green;
    case SnackType.error:
      return Colors.red;
  }
}

void snackBar(
  String title,
  String message, {
  SnackType type = SnackType.success,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: _getSnackbarColor(type),
    colorText: Colors.white,
  );
}

enum ToastType { success, warning, error, none }

enum ToastPosition { top, bottom }

void showToast(
  String message, {
  ToastType type = ToastType.none,
  Duration duration = const Duration(seconds: 3),
  ToastPosition position = ToastPosition.bottom,
}) {
  Color backgroundColor;
  Color textColor;

  switch (type) {
    case ToastType.success:
      backgroundColor = Colors.green.shade700;
      textColor = Colors.white;
      break;
    case ToastType.warning:
      backgroundColor = Colors.orange.shade700;
      textColor = Colors.white;
      break;
    case ToastType.error:
      backgroundColor = Colors.red.shade700;
      textColor = Colors.white;
      break;
    case ToastType.none:
      backgroundColor = Colors.grey.shade800;
      textColor = Colors.white;
      break;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: duration.inSeconds <= 2
        ? Toast.LENGTH_SHORT
        : Toast.LENGTH_LONG,
    gravity: position == ToastPosition.top
        ? ToastGravity.TOP
        : ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 14.0,
  );
}
