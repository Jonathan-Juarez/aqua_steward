import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
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
      activeColor: AppColor.containerContrast,
      inactiveThumbColor: AppColor.inactive,
      inactiveTrackColor: AppColor.containerContrastLight,
      contentPadding: AppPadding.symmetric4_8,
      secondary: IconFormat(icon: widget.icon),
      title: Text(widget.title, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(widget.subtitle, style: AppText.smallSecondary),
    );
  }
}
