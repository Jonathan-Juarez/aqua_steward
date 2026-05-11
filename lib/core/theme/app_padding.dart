import 'package:flutter/material.dart';

class AppPadding {
  // Usado para el containerFormat.
  static const EdgeInsetsGeometry all8 = EdgeInsets.all(8);
  // Usado para el scaffoldAccount.
  static const EdgeInsetsGeometry all16 = EdgeInsets.all(16);

  static const EdgeInsetsGeometry bottom16 = EdgeInsets.only(bottom: 16);

  static const EdgeInsetsGeometry symmetric16_0 = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 0,
  );
  // Usado en respuestas de los items del FAQ.
  static const EdgeInsetsGeometry symmetric0_16 = EdgeInsets.symmetric(
    vertical: 0,
    horizontal: 16,
  );
  // 8 arriba y abajo, 0 a los lados.
  static const EdgeInsetsGeometry symmetric8_0 = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 0,
  );
  // 0 arriba y abajo, 8 a los lados.
  static const EdgeInsetsGeometry symmetric0_8 = EdgeInsets.symmetric(
    vertical: 0,
    horizontal: 8,
  );
  static const EdgeInsetsGeometry right8 = EdgeInsets.only(right: 8);
}
