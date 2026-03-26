import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:flutter/material.dart';
// Asegúrate de importar tus archivos de AppColor, AppText, etc.

class FilterChipFormat extends StatelessWidget {
  const FilterChipFormat({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.right8,
      child: GestureDetector(
        // Al hacer clic, invierte el estado.
        onTap: () => onSelected(!isSelected),
        child: Container(
          padding: AppPadding.all8,
          decoration: BoxDecoration(
            color: isSelected
                ? colorsChip()
                : Theme.of(context).colorScheme.inversePrimary,

            borderRadius: AppBorder.all8,
          ),
          child: Row(
            children: [
              // Si está seleccionado se muestra un icono de check.
              if (isSelected) ...[AppIcon.check, AppSizedBox.width8],
              Text(
                label,
                style: isSelected ? AppText.smallWhite : AppText.small,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color colorsChip() {
    return label == "Nivel"
        ? AppColor.parameterAqua
        : label == "pH"
        ? AppColor.parameterPH
        : label == "Turbidez"
        ? AppColor.parameterTurbidity
        : AppColor.containerContrast;
  }
}
