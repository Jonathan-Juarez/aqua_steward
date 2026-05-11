import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class FilterChipFormat extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const FilterChipFormat({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.right8,
      child: InkWell(
        borderRadius: AppBorder.all8,
        // Al hacer clic, invierte el estado.
        onTap: () => onSelected(!isSelected),
        child: Container(
          padding: AppPadding.all8,
          decoration: BoxDecoration(
            color: isSelected
                ? colorsFilter(context)
                : Theme.of(context).colorScheme.inversePrimary,

            borderRadius: AppBorder.all8,
          ),
          child: TextFormat(
            text: label,
            context: context,
            type: isSelected ? "bodySmallWhite" : "bodySmall",
          ),
        ),
      ),
    );
  }

  Color colorsFilter(BuildContext context) {
    return label == context.l10n.sensor_nivel
        ? AppColor.parameterAqua
        : label == context.l10n.sensor_ph
        ? AppColor.parameterPH
        : label == context.l10n.sensor_turbidez
        ? AppColor.parameterTurbidity
        : AppColor.containerContrast;
  }
}
