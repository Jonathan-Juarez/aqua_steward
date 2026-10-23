import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit_snapshot.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/circular_progress_parameters.dart';
import 'package:aqua_steward/features/reading/presentation/widgets/deposit_level.dart';
import 'package:flutter/material.dart';

class DepositCard extends StatelessWidget {
  final DepositSnapshot snapshot;
  final Widget menuWidget;

  const DepositCard({
    super.key,
    required this.snapshot,
    required this.menuWidget,
  });

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
            "deposit": snapshot.deposit,
            "initialParameterIndex": index,
          },
        );
      },
      child: Center(
        child: Padding(
          padding: AppPadding.all8,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildCircular(int index) => CircularProgressParameters(
      index: index,
      snapshot: snapshot,
    );

    final secondary = snapshot.activeSecondaryIndices;

    return SizedBox(
      height: 350,
      child: ContainerFormat(
        children: [
          // Header de tarjeta
          Padding(
            padding: AppPadding.symmetric0_8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormat(
                    text: snapshot.deposit.name ?? "",
                    context: context,
                    type: "titleSmall",
                  ),
                ),
                menuWidget,
              ],
            ),
          ),

          // Sensores
          Expanded(
            child: Padding(
              padding: AppPadding.symmetric0_8,
              child: snapshot.isLevelActive && snapshot.hasSecondary
                  // Caso 1: Nivel (Izq) + Secundarios (Der)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _buildSensorItem(
                            context: context,
                            index: 0,
                            child: DepositLevel(level: snapshot.level),
                          ),
                        ),
                        AppSizedBox.width8,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final i in secondary)
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
                    )
                  : snapshot.isLevelActive
                  // Caso 2: Solo nivel
                  ? _buildSensorItem(
                      context: context,
                      index: 0,
                      child: DepositLevel(level: snapshot.level),
                    )
                  : snapshot.hasSecondary
                  // Caso 3: Solo secundarios
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int c = 0; c < secondary.length; c++) ...[
                          if (c > 0) AppSizedBox.width8,
                          Expanded(
                            child: _buildSensorItem(
                              context: context,
                              index: secondary[c],
                              child: buildCircular(secondary[c]),
                            ),
                          ),
                        ],
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
