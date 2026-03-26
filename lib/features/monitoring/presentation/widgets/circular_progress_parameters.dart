import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:flutter/material.dart';

class CircularProgressParameters extends StatelessWidget {
  const CircularProgressParameters({
    super.key,
    required this.index,
    required this.peakParameters,
    required this.imputParameters,
    required this.parametersLabel,
  });

  final int index;
  final List<double> peakParameters;
  final List<double> imputParameters;
  final List<String> parametersLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: peakParameters[index] == 0
                    ? 0
                    : imputParameters[index] /
                          // Ajuste visual para pH (escala 14)
                          (index == 2 ? 14.0 : peakParameters[index]),
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation(
                  index == 0
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
        AppSizedBox.height16,
        //Texto que muestra el valor actual del parámetro. El nivel lo colocaré sin decimales porque son valores grandes.
        Text(
          index == 0
              ? "${imputParameters[index]}"
              : "${imputParameters[index]}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        AppSizedBox.height8,
        Text(
          parametersLabel[index],
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
