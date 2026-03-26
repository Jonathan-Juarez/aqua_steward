import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:flutter/material.dart';

class ButtonDynamic extends StatelessWidget {
  final Icon? icon;
  final dynamic label;
  final VoidCallback? onPressed;
  final GlobalKey<FormState>? formKey;

  const ButtonDynamic({
    super.key,
    this.icon,
    this.label,
    this.onPressed,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return label != null
        ? TextButton(
            onPressed: () {
              if (formKey == null ||
                  (formKey!.currentState?.validate() ?? false)) {
                onPressed!();
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, AppSizedBox.width8],

                label is Text
                    ? label
                    : Text(label, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          )
        : IconButton(onPressed: onPressed, icon: icon!);
  }
}
