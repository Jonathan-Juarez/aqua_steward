import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class TextFormat extends StatelessWidget {
  final String? type;
  final String text;
  final BuildContext context;
  final bool? alignCenter;
  const TextFormat({
    super.key,
    required this.text,
    required this.context,
    this.type,
    this.alignCenter,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "title":
        return Text(text, style: Theme.of(context).textTheme.titleMedium);
      case "titleSmall":
        return Text(text, style: Theme.of(context).textTheme.titleSmall);
      case "subtitle":
        return Padding(
          padding: AppPadding.symmetric16_0,
          child: Text(text, style: Theme.of(context).textTheme.titleSmall),
        );
      case "body":
        return Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: alignCenter == true ? TextAlign.center : null,
        );
      case "bodyWhite":
        return Text(text, style: AppText.bodyWhite);
      case "bodyRed":
        return Text(text, style: AppText.bodyRed);
      case "bodySecondary":
        return Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: alignCenter == true ? TextAlign.center : null,
        );
      case "bodySmall":
        return Text(text, style: Theme.of(context).textTheme.bodySmall);
      case "bodySmallWhite":
        return Text(text, style: AppText.smallWhite);
      case "label":
        return Text(text, style: Theme.of(context).textTheme.labelMedium);
      default:
        return Text(text, style: Theme.of(context).textTheme.titleLarge);
    }
  }
}
