import 'package:flutter/material.dart';

extension ModifiedColors on Color {
  Color getColor({required String colorCode}) =>
      Color(0xff + int.parse(colorCode));
}
