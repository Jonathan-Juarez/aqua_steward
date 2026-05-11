import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppText {
  // TEXTOS ESTÁTICOS
  // Texto para botón general.
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColor.white,
  );
  // Texto de cuerpo (encima de color azulado).
  static const TextStyle bodyWhite = TextStyle(
    fontSize: 16,
    color: AppColor.white,
  );
  static const TextStyle bodyRed = TextStyle(
    fontSize: 16,
    color: AppColor.error,
  );
  // Textos pequeños.
  static const TextStyle smallWhite = TextStyle(
    fontSize: 14,
    color: AppColor.white,
  );
}
