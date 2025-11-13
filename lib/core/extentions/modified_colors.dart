import 'package:flutter/material.dart';

extension ModifiedColors on Color {
  Color modify({required String colorCode}) {
    String formattedCode = colorCode.startsWith('0xff')
        ? colorCode
        : '0xff$colorCode';
    return Color(int.parse(formattedCode));
  }
}
