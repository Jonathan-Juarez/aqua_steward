import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class ButtonFormat extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final GlobalKey<FormState>? formKey;
  final String? type;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const ButtonFormat({
    super.key,
    this.icon,
    this.label,
    this.onCancel,
    this.onConfirm,
    this.formKey,
    this.type,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "text":
        return TextButton(
          onPressed: isLoading ? null : formValidate,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Muestra el icono si se proporciona uno.
              if (icon != null && !isLoading) ...[
                icon!,
                AppSizedBox.width8,
                Text(label!, style: Theme.of(context).textTheme.titleSmall),
              ],
              if (!isLoading)
                Text(label!, style: Theme.of(context).textTheme.titleSmall),

              // Muestra un indicador de carga pequeño si la acción está en proceso.
              if (isLoading) ...[
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
        );
      case "dialog":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.error,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppBorder.all8,
                ),
                minimumSize: const Size(0, 35),
              ),
              child: TextFormat(
                text: context.l10n.comun_cancelar,
                type: "bodySmallWhite",
                context: context,
              ),
            ),
            AppSizedBox.width8,
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.success,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppBorder.all8,
                ),
                minimumSize: const Size(0, 35),
              ),
              child: TextFormat(
                text: context.l10n.comun_confirmar,
                type: "bodySmallWhite",
                context: context,
              ),
            ),
          ],
        );
      case "icon":
        return IconButton(onPressed: onConfirm, icon: icon!);
      default:
        return Padding(
          padding: padding ?? AppPadding.symmetric16_0,
          child: ElevatedButton(
            onPressed: isLoading ? null : formValidate,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(child: Text(label!)),
          ),
        );
    }
  }

  void formValidate() {
    if (formKey == null || (formKey!.currentState?.validate() ?? false)) {
      onConfirm!();
    }
  }
}
