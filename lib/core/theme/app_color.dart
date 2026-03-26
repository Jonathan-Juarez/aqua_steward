import 'package:flutter/material.dart';

class AppColor {
  // MODO OSCURO
  static const Color background = Color(0xFF010915);
  static const Color container = Color(0xFF111A27);
  static const Color containerContrast = Color(0xFF1E3A5F);

  static const Color inactive = Colors.white24;

  // Tipografía Modo Oscuro
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteSecondary = Color(0xFF94A3B8);

  // MODO CLARO
  static const Color backgroundLight = Color(0xFFF5F5F5);
  //No se coloca el containerLight porque es el blanco puro.
  static const Color containerContrastLight = Color(0xFFE2E8F0);

  // Tipografía Modo Claro
  static const Color black = Color(0xFF0F172A);
  static const Color blackSecondary = Color(0xFF475569);
  static const Color inactiveLight = Color(0x1F000000);

  // ESTÁTICOS
  static const Color parameterAqua = Color(0xFF4A90E2);
  static const Color parameterTurbidity = Color(0xFF00B8D4);
  static const Color parameterPH = Color(0xFFA66DD4);

  // Colores Reactivos
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF016475);
  static const Color warning = Color(0xFFF59E0B);
}
