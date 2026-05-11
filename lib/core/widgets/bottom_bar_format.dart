import 'package:aqua_steward/core/extensions/l10n_extensions.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class BottomBarFormat extends StatelessWidget {
  const BottomBarFormat({super.key});

  @override
  Widget build(BuildContext context) {
    // Se obtiene la ruta actual para determinar el índice seleccionado.
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final int selectedIndex = currentRoute == AppRouter.profile ? 1 : 0;

    // Lista de items de la barra.
    final List<Map<String, dynamic>> items = [
      {
        "icon": selectedIndex == 0 ? AppIcon.home : AppIcon.homeOutlined,
        "label": context.l10n.button_inicio,
        "route": AppRouter.dashboard,
      },
      {
        "icon": selectedIndex == 1
            ? AppIcon.person
            : AppIcon.personOutlined(color: AppColor.white),
        "label": context.l10n.button_perfil,
        "route": AppRouter.profile,
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
                route: items[i]["route"],
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
    required String route,
  }) {
    return InkWell(
      onTap: () {
        if (index != selectedIndex) {
          Navigator.pushReplacementNamed(context, route);
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
