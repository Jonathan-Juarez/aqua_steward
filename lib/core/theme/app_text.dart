import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppText {
  // TEXTOS DINÁMICOS

  //Texto para cuerpo.
  // static const TextStyle body = TextStyle(fontSize: 16);
  // static const TextStyle bodyBold = TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.bold,
  // );
  // Texto pequeño
  static const TextStyle small = TextStyle(fontSize: 14);
  // Texto gráfico.
  static const TextStyle graph = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  // TEXTOS ESTÁTICOS
  // Texto para botón general.
  static const TextStyle button = TextStyle(
    fontSize: 20,
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
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 16,
    color: AppColor.whiteSecondary,
  );
  // Textos pequeños.
  static const TextStyle smallWhite = TextStyle(
    fontSize: 14,
    color: AppColor.white,
  );
  static const TextStyle smallSecondary = TextStyle(
    fontSize: 14,
    color: AppColor.whiteSecondary,
  );
  static const TextStyle smallRed = TextStyle(
    fontSize: 14,
    color: AppColor.error,
    fontWeight: FontWeight.bold,
  );
}
