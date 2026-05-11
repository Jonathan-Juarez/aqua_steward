import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class CircularProgressParameters extends StatelessWidget {
  final int index;
  final List<double> peakParameters;
  final List<double> imputParameters;
  final List<String> parametersLabel;
  final List<String> unit;
  final Map<String, dynamic> depositData;

  const CircularProgressParameters({
    super.key,
    required this.index,
    required this.peakParameters,
    required this.imputParameters,
    required this.parametersLabel,
    required this.unit,
    required this.depositData,
  });

  @override
  Widget build(BuildContext context) {
    late double? minValue;
    late double? maxValue;
    late double currentValue;
    // Determinamos si el valor está fuera de los umbrales definidos en depositData.
    bool hasError = false;
    final sensors = depositData["sensors"];
    final sensorType = ["HC-SR04", "PH-4502C", "TS300B"][index];
    final sensor = sensors.firstWhere(
      (sensor) => (sensor is Map ? sensor["type"] : sensor.type) == sensorType,
    );

    minValue = sensor is Map
        ? (sensor["min_value"] as num?)?.toDouble()
        : sensor.minValue;
    maxValue = sensor is Map
        ? (sensor["max_value"] as num?)?.toDouble()
        : sensor.maxValue;
    currentValue = imputParameters[index];

    if ((minValue != null && currentValue < minValue) ||
        (maxValue != null && currentValue > maxValue)) {
      hasError = true;
    }

    return Column(
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
                  value: peakParameters[index] == 0
                      ? 0.0
                      : (imputParameters[index] /
                            (unit[index] == "%" ? 100 : peakParameters[index])),
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation(
                    hasError
                        ? AppColor.error
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
        //Texto que muestra el valor actual del parámetro. Puede que el nivel se muestre sin decimales porque son valores grandes.
        if (unit[index] != "pH")
          TextFormat(
            text: "${imputParameters[index]} ${unit[index]}",
            context: context,
            type: "body",
          ),
        if (unit[index] == "pH")
          TextFormat(
            text: imputParameters[index].toString(),
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
