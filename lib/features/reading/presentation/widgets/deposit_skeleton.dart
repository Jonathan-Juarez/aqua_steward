import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DepositSkeleton extends StatelessWidget {
  const DepositSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerFormat(
      children: [
        // Silueta de título y botón menú.
        Padding(
          padding: AppPadding.symmetric0_8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormat(
                text: "Nombre del Depósito",
                context: context,
                type: "titleSmall",
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
        AppSizedBox.height12,
        // Silueta de sensores: sensor de nivel a la izquierda y métricas secundarias a la derecha.
        const Padding(
          padding: AppPadding.symmetric0_8,
          child: Row(
            children: [
              // Silueta del sensor de nivel a la izquierda.
              Expanded(
                flex: 1,
                child: Bone(height: 160, borderRadius: AppBorder.all8),
              ),
              AppSizedBox.width8,
              // Silueta de pH y turbidez a la derecha.
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Bone(
                      height: 76,
                      borderRadius: AppBorder.all8,
                      width: double.infinity,
                    ),
                    AppSizedBox.height8,
                    Bone(
                      height: 76,
                      borderRadius: AppBorder.all8,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
