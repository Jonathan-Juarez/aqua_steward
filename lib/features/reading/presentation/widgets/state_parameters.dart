import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:flutter/material.dart';

class StateParameters {
  static String show(BuildContext context, double inputValue, String unit) {
    if (unit == "pH") {
      if (inputValue < 0 || inputValue > 14)
        // ignore: curly_braces_in_flow_control_structures
        return context.l10n.estado_error_lectura;
      if (inputValue < 6.0) return context.l10n.estado_muy_acido;
      if (inputValue < 6.5) return context.l10n.estado_acido;
      if (inputValue <= 8.5) return context.l10n.estado_optimo;
      if (inputValue <= 10.0) return context.l10n.estado_alcalino;
      return context.l10n.estado_muy_alcalino;
    }

    if (unit == "NTU") {
      if (inputValue < 0) return context.l10n.estado_error_lectura;
      if (inputValue <= 1.0) return context.l10n.estado_ideal;
      if (inputValue <= 5.0) return context.l10n.estado_aceptable;
      if (inputValue <= 20.0) return context.l10n.estado_turbio;
      return context.l10n.estado_muy_turbio;
    }

    return "";
  }
}
