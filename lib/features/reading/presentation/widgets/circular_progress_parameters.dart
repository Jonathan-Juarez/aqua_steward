import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit_snapshot.dart';
import 'package:flutter/material.dart';

class CircularProgressParameters extends StatelessWidget {
  final int index;
  final DepositSnapshot snapshot;

  const CircularProgressParameters({
    super.key,
    required this.index,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final parametersLabel = [
      context.l10n.sensor_nivel,
      context.l10n.sensor_ph,
      context.l10n.sensor_turbidez,
    ];
    final unit = snapshot.unitAt(index);
    final value = snapshot.valueAt(index);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: AppPadding.all16,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: snapshot.progressAt(index),
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation(
                    snapshot.isOutOfRange(index)
                        ? AppColor.warning
                        : index == 0
                        ? AppColor.parameterAqua
                        : index == 1
                        ? AppColor.parameterPH
                        : AppColor.parameterTurbidity,
                  ),
                ),
              ),
              index == 0
                  ? AppIcon.waterDrop
                  : index == 1
                  ? AppIcon.scienceRounded
                  : AppIcon.water,
            ],
          ),
        ),
        // Texto que muestra el valor actual del parámetro.
        TextFormat(
          text: unit == "pH" ? value.toString() : "$value $unit",
          context: context,
          type: "body",
        ),
        TextFormat(
          text: parametersLabel[index],
          context: context,
          type: "bodySmall",
        ),
      ],
    );
  }
}
