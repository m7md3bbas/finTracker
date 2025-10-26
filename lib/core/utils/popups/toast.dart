import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastNotifier {
  static void showSuccess(String message) => Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.green,
    gravity: ToastGravity.CENTER,
    textColor: Colors.white,
  );

  static void showError(String message) => Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.red,
  );
}
