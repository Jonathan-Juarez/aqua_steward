import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:flutter/material.dart';

class ContainerFormat extends StatelessWidget {
  final List<Widget> children;

  const ContainerFormat({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: AppBorder.all8,
      ),
      child: Padding(
        padding: AppPadding.all16,
        child: Column(children: children),
      ),
    );
  }
}
