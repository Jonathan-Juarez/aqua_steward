import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class MenuItemModel {
  final String value;
  final Widget icon;
  final String text;
  final String? textStyle;

  MenuItemModel({
    required this.value,
    required this.icon,
    required this.text,
    this.textStyle,
  });
}

class MenuButtonFormat extends StatelessWidget {
  final List<MenuItemModel> items;
  final ValueChanged<String> onSelected;
  final Icon? iconMenu;
  final Widget? child;

  const MenuButtonFormat({
    super.key,
    required this.items,
    required this.onSelected,
    this.iconMenu = AppIcon.moreHoriz,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0.1, 0),
      icon: child != null ? null : iconMenu,
      borderRadius: AppBorder.all8,
      onSelected: onSelected,
      child: child,
      itemBuilder: (BuildContext context) {
        return items.map(
          (item) {
            return PopupMenuItem<String>(
              value: item.value,
              child: Row(
                children: [
                  item.icon,
                  AppSizedBox.width8,
                  TextFormat(
                    text: item.text,
                    context: context,
                    type: item.textStyle ?? "body",
                  ),
                ],
              ),
            );
          },
        ).toList(); //Se debe retornar la lista de las opciones que trae el menú.
      },
    );
  }
}
