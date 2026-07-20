import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart' show AppColor;
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class SnackBarFormat {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(borderRadius: AppBorder.all8),
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: AppText.bodyWhite),
        duration: const Duration(seconds: 1, milliseconds: 500),
        backgroundColor: _getColor(message),
      ),
    );
  }

  static Color _getColor(String message) {
    if (message.toLowerCase().contains("error")) {
      return Colors.red;
    }
    return AppColor.containerContrast;
  }
}
