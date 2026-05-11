import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// SwitchListTile permite mostrar una lista de opciones con un interruptor.
class SwitchFormat extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Icon icon;
  final ValueChanged<bool> onChanged;
  const SwitchFormat({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  @override
  State<SwitchFormat> createState() => _SwitchFormatState();
}

class _SwitchFormatState extends State<SwitchFormat> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: widget.value,
      onChanged: widget.onChanged,
      inactiveThumbColor: Theme.of(context).colorScheme.onSurfaceVariant,
      inactiveTrackColor: Theme.of(context).colorScheme.inversePrimary,
      contentPadding: AppPadding.symmetric0_8,
      secondary: IconFormat(icon: widget.icon),
      title: TextFormat(text: widget.title, context: context, type: "body"),
      subtitle: TextFormat(
        text: widget.subtitle,
        context: context,
        type: "bodySmall",
      ),
    );
  }
}
