import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/providers/language_provider.dart';
import 'package:aqua_steward/core/providers/theme_provider.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_format.dart';
import 'package:aqua_steward/core/widgets/dialog_emergent.dart';
import 'package:aqua_steward/core/widgets/filter_chip_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Diálogo para cambiar el tema y el idioma de la aplicación.
class DialogSettings {
  static Future<void> show(BuildContext context) async {
    final themeProvider = context.read<ThemeProvider>();
    final languageProvider = context.read<LanguageProvider>();

    // Obtiene los valores actuales para el estado local del diálogo.
    String pendingTheme = themeProvider.themeMode == ThemeMode.system
        ? "system"
        : themeProvider.themeMode == ThemeMode.light
        ? "light"
        : "dark";
    String pendingLanguage = languageProvider.locale.languageCode;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return DialogEmergent(
              title: context.l10n.perfil_personalizacion,
              onPressed: () {
                // Aplica los cambios de tema e idioma al confirmar.
                themeProvider.setTheme(pendingTheme);
                languageProvider.setLanguage(pendingLanguage);
                Navigator.of(context).pop();
              },
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormat(
                    text: context.l10n.perfil_tema,
                    context: context,
                    type: "body",
                  ),
                  AppSizedBox.height12,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ButtonFormat(
                          type: "icon",
                          icon: AppIcon.systemMode,
                          isSelected: pendingTheme == "system",
                          onConfirm: () =>
                              setDialogState(() => pendingTheme = "system"),
                        ),
                        ButtonFormat(
                          type: "icon",
                          icon: AppIcon.lightMode,
                          isSelected: pendingTheme == "light",
                          onConfirm: () =>
                              setDialogState(() => pendingTheme = "light"),
                        ),
                        ButtonFormat(
                          type: "icon",
                          icon: AppIcon.darkMode,
                          isSelected: pendingTheme == "dark",
                          onConfirm: () =>
                              setDialogState(() => pendingTheme = "dark"),
                        ),
                      ],
                    ),
                  ),
                  AppSizedBox.height12,
                  TextFormat(
                    text: context.l10n.perfil_idioma,
                    context: context,
                    type: "body",
                  ),
                  AppSizedBox.height12,
                  Row(
                    children: [
                      FilterChipFormat(
                        label: context.l10n.perfil_espanol,
                        isSelected: pendingLanguage == 'es',
                        onSelected: (_) =>
                            setDialogState(() => pendingLanguage = "es"),
                      ),
                      FilterChipFormat(
                        label: context.l10n.perfil_ingles,
                        isSelected: pendingLanguage == 'en',
                        onSelected: (_) =>
                            setDialogState(() => pendingLanguage = "en"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
