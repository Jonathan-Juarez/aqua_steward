import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:flutter/material.dart';

class IconFormat extends StatelessWidget {
  final Icon icon;
  const IconFormat({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all8,
      decoration: BoxDecoration(
        color: Theme.of(context).iconTheme.color?.withOpacity(0.05),
        borderRadius: AppBorder.all8,
      ),
      child: icon,
    );
  }
}
