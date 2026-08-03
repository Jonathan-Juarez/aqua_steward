import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class BottomBarFormat extends StatelessWidget {
  final Function(int index)? onTap;
  final int selectedIndex;

  const BottomBarFormat({
    super.key,
    this.onTap,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Lista de items de la barra.
    final List<Map<String, dynamic>> items = [
      {
        "icon": selectedIndex == 0 ? AppIcon.home : AppIcon.homeOutlined,
        "label": context.l10n.button_inicio,
      },
      {
        "icon": selectedIndex == 1
            ? AppIcon.person
            : AppIcon.personOutlined(color: AppColor.white),
        "label": context.l10n.button_perfil,
      },
    ];

    return BottomAppBar(
      // Se quitan todos los paddings de Material 3 que deforman la barra.
      padding: EdgeInsets.zero,
      // Se define la forma de la barra, dejando espacio para el botón flotante.
      shape: const CircularNotchedRectangle(),
      // Se añade el clip para que el efecto splash del InkWell respete la forma de la barra.
      clipBehavior: Clip.antiAlias,
      height: 60,
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            Expanded(
              child: TabIcon(
                context: context,
                index: i,
                selectedIndex: selectedIndex,
                icon: items[i]["icon"],
                label: items[i]["label"],
              ),
            ),
        ],
      ),
    );
  }

  Widget TabIcon({
    required BuildContext context,
    required int index,
    required int selectedIndex,
    required Icon icon,
    required String label,
  }) {
    return InkWell(
      onTap: () {
        if (index != selectedIndex && onTap != null) {
          onTap!(index);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(label, style: AppText.smallWhite),
        ],
      ),
    );
  }
}
