import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/circular_progress_parameters.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/deposit_level.dart';
import 'package:flutter/material.dart';

class DepositCard extends StatelessWidget {
  final Map<String, dynamic> depositData;
  final Widget menuWidget;

  const DepositCard({
    super.key,
    required this.depositData,
    required this.menuWidget,
  });

  bool _isSensorActive(dynamic sensors, int index) {
    if (sensors == null || sensors is! List || index >= sensors.length) {
      return true;
    }
    final sensor = sensors[index];
    return (sensor is Map ? sensor["state"] as bool? : null) ?? true;
  }

  Widget _buildSensorItem({
    required BuildContext context,
    required int index,
    required Widget child,
  }) {
    return InkWell(
      borderRadius: AppBorder.all8,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.detailScreen,
          arguments: {
            "depositData": depositData,
            "initialParameterIndex": index,
          },
        );
      },
      child: Padding(
        padding: AppPadding.all8,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensors = depositData["sensors"];

    final double inputLevel = (depositData["inputLevel"] as num).toDouble();
    final double inputPh = (depositData["inputPh"] as num).toDouble();
    final double inputTurbidity = (depositData["inputTurbidity"] as num)
        .toDouble();

    final double peakLevel = (depositData["peakLevel"] as num).toDouble();
    final double peakPh = (depositData["peakPh"] as num).toDouble();
    final double peakTurbidity = (depositData["peakTurbidity"] as num)
        .toDouble();

    final List<String> parametersLabel = [
      context.l10n.sensor_nivel,
      context.l10n.sensor_ph,
      context.l10n.sensor_turbidez,
    ];
    final List<double> peakParameters = [peakLevel, peakPh, peakTurbidity];
    final List<double> inputParameters = [inputLevel, inputPh, inputTurbidity];
    final List<String> unitParameters = ["%", "pH", "NTU"];

    final bool isLevelActive = _isSensorActive(sensors, 0);
    final bool isPhActive = _isSensorActive(sensors, 1);
    final bool isTurbidityActive = _isSensorActive(sensors, 2);
    final bool hasSecondary = isPhActive || isTurbidityActive;

    Widget buildCircular(int index) => CircularProgressParameters(
      index: index,
      peakParameters: peakParameters,
      imputParameters: inputParameters,
      parametersLabel: parametersLabel,
      unit: unitParameters,
      depositData: depositData,
    );

    return ContainerFormat(
      children: [
        // Header de tarjeta
        Padding(
          padding: AppPadding.symmetric0_8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormat(
                text: depositData["name"],
                context: context,
                type: "titleSmall",
              ),
              menuWidget,
            ],
          ),
        ),

        // Sensores
        Padding(
          padding: AppPadding.symmetric0_8,
          child: isLevelActive && hasSecondary
              // Caso 1: Nivel (Izq) + Secundarios (Der)
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _buildSensorItem(
                          context: context,
                          index: 0,
                          child: DepositLevel(level: inputLevel),
                        ),
                      ),
                      AppSizedBox.width8,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 1; i < 3; i++)
                              if (_isSensorActive(sensors, i))
                                Expanded(
                                  child: _buildSensorItem(
                                    context: context,
                                    index: i,
                                    child: buildCircular(i),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : isLevelActive
              // Caso 2: Solo nivel
              ? Center(
                  child: _buildSensorItem(
                    context: context,
                    index: 0,
                    child: DepositLevel(level: inputLevel),
                  ),
                )
              // Caso 3: Solo secundarios
              : Row(
                  children: [
                    for (int i = 1; i < 3; i++)
                      if (_isSensorActive(sensors, i))
                        Expanded(
                          child: _buildSensorItem(
                            context: context,
                            index: i,
                            child: buildCircular(i),
                          ),
                        ),
                  ],
                ),
        ),
      ],
    );
  }
}
