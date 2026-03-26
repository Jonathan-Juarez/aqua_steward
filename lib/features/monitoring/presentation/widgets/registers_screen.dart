import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/parameter_chart.dart';
import 'package:flutter/material.dart';

class RegistersScreen extends StatelessWidget {
  final String summaryLabel, summaryValue;
  final Color color;
  final Icon icon;
  final double maxY;
  final String unit;
  final String asset;
  const RegistersScreen({
    super.key,
    required this.summaryLabel,
    required this.summaryValue,
    required this.color,
    required this.icon,
    required this.maxY,
    required this.unit,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tarjeta de Resumen
        ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.all8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summaryLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      AppSizedBox.height8,
                      Text(
                        summaryValue,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: icon,
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSizedBox.height16,

        // Gráfico
        ParameterChart(
          asset: asset,
          titleParameter: 'Historial',
          color: color,
          maxY: maxY,
          unit: unit,
          // type: "linea",
        ),

        AppSizedBox.height16,
        ButtonMain(label: "Exportar CSV", onPressed: () {}),
      ],
    );
  }
}
