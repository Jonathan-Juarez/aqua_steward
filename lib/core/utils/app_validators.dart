import 'package:flutter/material.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';

class AppValidators {
  // Validador para campos requeridos
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

  //Valiador de campos únicos.
  static String? validateUnique(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nº";
    }
    return null;
  }

  // Validador de correo electrónico
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validar_campo_requerido;
    }
    // Expresión regular básica para validar email
    final emailRegex = RegExp(
      r"^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+",
    );
    // Si el correo no cumple con la expresión regular, devuelve un mensaje de error.
    return !emailRegex.hasMatch(value)
        ? context.l10n.validar_correo_invalido
        : null;
  }

  // Validador de contraseña
  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validar_campo_requerido;
    }
    final passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$",
    );
    return !passwordRegex.hasMatch(value)
        ? context.l10n.validar_contrasena_invalida
        : null;
  }

  // Validador de IP.
  static String? validateIP(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validar_campo_requerido;
    }
    final ipRegex = RegExp(
      r"^((25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)(\.)){3}(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$",
    );
    return !ipRegex.hasMatch(value) ? context.l10n.validar_ip_invalida : null;
  }
}
