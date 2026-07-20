import 'package:flutter/material.dart';
import 'package:aqua_steward/core/extensions/l10n_extensions.dart';

// Formateador de tiempo.
class FormaterTime {
  final DateTime dateTime;
  final BuildContext context;

  FormaterTime({required this.dateTime, required this.context});

  String format() {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return context.l10n.tiempo_ahora;
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return context.l10n.tiempo_hace_minutos(minutes);
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return context.l10n.tiempo_hace_horas(hours);
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return context.l10n.tiempo_hace_dias(days);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return context.l10n.tiempo_hace_semanas(weeks);
    } else {
      final months = (difference.inDays / 30).floor();
      return context.l10n.tiempo_hace_meses(months);
    }
  }
}
