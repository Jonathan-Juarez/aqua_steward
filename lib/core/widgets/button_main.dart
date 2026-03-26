import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:aqua_steward/core/theme/app_circular_progress.dart';
import 'package:flutter/material.dart';

class ButtonMain extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final GlobalKey<FormState>? formKey;
  final bool isLoading;

  const ButtonMain({
    super.key,
    required this.label,
    required this.onPressed,
    this.formKey,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric8_0,
      // Material trabaja con el lienzo estático que aparece al presionar.
      child: Material(
        borderRadius: AppBorder.all8,
        // Ink es como un contenedor que puede trabajar con el efecto tinta al presionar un botón.
        child: Ink(
          width: double.infinity,
          height: 45,
          decoration: const BoxDecoration(
            color: AppColor.containerContrast,
            borderRadius: AppBorder.all8,
          ),
          // InkWell trabaja con el lienzo dinámico que aparece al presionar.
          child: InkWell(
            borderRadius: AppBorder.all8,
            onTap: () {
              // Validación del formulario. Si no hay formKey, se asume válido.
              if (formKey == null ||
                  (formKey!.currentState?.validate() ?? false)) {
                onPressed();
              }
            },
            child: isLoading
                ? const Center(
                    child: AppCircularProgress.circularProgressFormat,
                  )
                : Center(child: Text(label, style: AppText.button)),
          ),
        ),
      ),
    );
  }
}
