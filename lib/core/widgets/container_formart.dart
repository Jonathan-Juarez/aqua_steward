import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:flutter/material.dart';

class ContainerFormat extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onTap;
  final Color? color;

  const ContainerFormat({
    super.key,
    required this.children,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.primary,
        borderRadius: AppBorder.all8,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 0.5,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: AppBorder.all8,
        onTap: onTap,
        child: Padding(
          padding: AppPadding.all8,
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}
