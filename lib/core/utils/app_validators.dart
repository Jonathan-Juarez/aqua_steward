import 'package:flutter/material.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';

class AppValidators {
  // Validador para campos requeridos.
  static String? validateRequired(BuildContext context, String? value) {
    return value == null || value.trim().isEmpty
        ? context.l10n.validar_campo_requerido
        : null;
  }

  // Validador de números.
  static String? validateNumber(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validar_campo_requerido;
    }
    final numberRegex = RegExp(r"^[0-9]+(\.[0-9]+)?$");
    return !numberRegex.hasMatch(value)
        ? context.l10n.validar_numero_invalido
        : null;
  }

  // Validador de campos únicos.
  static String? validateUnique(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nº";
    }
    return null;
  }

  // Validador de correo electrónico.
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validar_campo_requerido;
    }
    final emailRegex = RegExp(
      r"^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+",
    );
    return !emailRegex.hasMatch(value)
        ? context.l10n.validar_correo_invalido
        : null;
  }

  // Métodos de evaluación individual para los requisitos de contraseña.
  static bool hasMinLength(String pwd) => pwd.length >= 8;
  static bool hasUppercase(String pwd) => RegExp(r'[A-Z]').hasMatch(pwd);
  static bool hasLowercase(String pwd) => RegExp(r'[a-z]').hasMatch(pwd);
  static bool hasNumber(String pwd) => RegExp(r'\d').hasMatch(pwd);
  static bool hasSpecialChar(String pwd) => RegExp(r'[\W_]').hasMatch(pwd);

  // Validador de contraseña general.
  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validar_campo_requerido;
    }
    final isValid =
        hasMinLength(value) &&
        hasLowercase(value) &&
        hasUppercase(value) &&
        hasNumber(value) &&
        hasSpecialChar(value);
    return !isValid ? context.l10n.validar_contrasena_invalida : null;
  }

  // Validador de Dirección MAC.
  static String? validateMac(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validar_campo_requerido;
    }
    final trimmed = value.trim();
    // Acepta formato MAC con separadores (XX:XX:XX:XX:XX:XX o XX-XX-XX-XX-XX-XX) o 12 caracteres hex continuos.
    final macRegex = RegExp(r"^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$");
    final rawHexRegex = RegExp(r"^[0-9A-Fa-f]{12}$");

    final isValid = macRegex.hasMatch(trimmed) || rawHexRegex.hasMatch(trimmed);

    return !isValid ? context.l10n.validar_mac_invalida : null;
  }
}
