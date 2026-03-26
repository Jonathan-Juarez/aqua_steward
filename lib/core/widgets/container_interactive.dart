import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:flutter/material.dart';

class ContainerInteractive extends StatefulWidget {
  final Function() onTap;
  final String title;
  final Icon icon;
  const ContainerInteractive({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  State<ContainerInteractive> createState() => _ContainerInteractiveState();
}

class _ContainerInteractiveState extends State<ContainerInteractive> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric8_0,
      child: GestureDetector(
        onTap: widget.onTap,
        child: ContainerFormat(
          children: [
            Padding(
              padding: AppPadding.all8,
              child: Row(
                children: [
                  IconFormat(icon: widget.icon),
                  AppSizedBox.width8,
                  Text(
                    widget.title,
                    style: widget.icon == AppIcon.logoutOutlined
                        ? AppText.bodyRed
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  AppIcon.arrowRight,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
