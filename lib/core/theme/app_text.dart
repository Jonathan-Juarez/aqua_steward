import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  // TEXTOS ESTÁTICOS
  // Texto para botón general.
  static final TextStyle button = GoogleFonts.publicSans(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColor.white,
  );
  // Texto de cuerpo (encima de color azulado).
  static final TextStyle bodyWhite = GoogleFonts.publicSans(
    fontSize: 16,
    color: AppColor.white,
  );
  static final TextStyle bodyRed = GoogleFonts.publicSans(
    fontSize: 16,
    color: AppColor.error,
  );
  // Textos pequeños.
  static final TextStyle smallWhite = GoogleFonts.publicSans(
    fontSize: 14,
    color: AppColor.white,
  );
}
