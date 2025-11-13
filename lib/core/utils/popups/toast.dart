import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastNotifier {
  static void showSuccess(String message) => Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.white.modify(colorCode: AppColors.mainCardColor),
    gravity: ToastGravity.TOP,
    textColor: Colors.white,
  );

  static void showError(String message) => Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.red,
  );
}
