import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class MenuItemModel {
  final String value;
  final Widget icon;
  final String text;
  final TextStyle? textStyle;

  MenuItemModel({
    required this.value,
    required this.icon,
    required this.text,
    this.textStyle = AppText.small,
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
      icon: child != null ? null : iconMenu,
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
                  Text(item.text, style: item.textStyle),
                ],
              ),
            );
          },
        ).toList(); //Se debe retornar la lista de las opciones que trae el menú.
      },
    );
  }
}
