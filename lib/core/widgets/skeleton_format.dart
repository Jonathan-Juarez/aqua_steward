import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonFormat extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const SkeletonFormat({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Skeletonizer(
      enabled: isLoading,
      // Se personalizan los colores para que sean coherentes con el modo oscuro/claro.
      effect: ShimmerEffect(
        baseColor: isDark
            ? AppColor.whiteSecondary.withOpacity(0.15)
            : AppColor.blackSecondary.withOpacity(0.15),
        highlightColor: isDark
            ? AppColor.white.withOpacity(0.30)
            : AppColor.blackSecondary.withOpacity(0.04),
        duration: const Duration(milliseconds: 1000),
      ),
      child: child,
    );
  }
}
