import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/core/widgets/icon_format.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class ContainerListTile extends StatefulWidget {
  final Function()? onTap;
  final dynamic title;
  final Icon? icon;
  final String? subtitle;
  final dynamic subsubtitle;
  final Widget? trailing;
  final bool showTrailing;
  const ContainerListTile({
    super.key,
    this.onTap,
    required this.title,
    this.icon,
    this.subtitle,
    this.subsubtitle,
    this.trailing,
    this.showTrailing = true,
  });

  @override
  State<ContainerListTile> createState() => _ContainerListTileState();
}

class _ContainerListTileState extends State<ContainerListTile> {
  @override
  Widget build(BuildContext context) {
    return ContainerFormat(
      onTap: widget.onTap,
      children: [
        ListTile(
          leading: widget.icon != null ? IconFormat(icon: widget.icon!) : null,
          title: widget.title is TextFormat
              ? widget.title
              : TextFormat(
                  text: widget.title,
                  context: context,
                  type: widget.title == context.l10n.perfil_cerrar_sesion
                      ? "bodyRed"
                      : "body",
                ),
          subtitle: widget.subsubtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.subtitle != null) ...[
                      TextFormat(
                        text: widget.subtitle!,
                        context: context,
                        type: "body",
                      ),
                    ],
                    widget.subsubtitle is String
                        ? TextFormat(
                            text: widget.subsubtitle,
                            context: context,
                            type: "bodySmall",
                          )
                        : widget.subsubtitle,
                  ],
                )
              : widget.subtitle != null
              ? TextFormat(
                  text: widget.subtitle!,
                  context: context,
                  type: "bodySmall",
                )
              : null,
          contentPadding: AppPadding.symmetric0_8,
          trailing: widget.showTrailing
              ? (widget.trailing ??
                    (widget.title == context.l10n.perfil_cerrar_sesion
                        ? AppIcon.arrowRight()
                        : AppIcon.arrowRight(
                            color: Theme.of(context).colorScheme.onSurface,
                          )))
              : null,
        ),
      ],
    );
  }
}
