import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart' show AppColor;
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class SnackBarFormat {
  final BuildContext context;
  final String message;
  final bool? isError;
  SnackBarFormat({required this.context, required this.message, this.isError});

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(borderRadius: AppBorder.all8),
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: AppText.bodyWhite),
        duration: const Duration(seconds: 1, milliseconds: 500),
        backgroundColor: isError == true
            ? AppColor.error
            : AppColor.containerContrast,
      ),
    );
  }
}
