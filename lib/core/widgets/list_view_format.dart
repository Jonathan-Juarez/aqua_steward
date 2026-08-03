import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:flutter/material.dart';

class ListViewFormat extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;

  const ListViewFormat({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (_, _) => AppSizedBox.height12,
      itemBuilder: itemBuilder,
    );
  }
}
