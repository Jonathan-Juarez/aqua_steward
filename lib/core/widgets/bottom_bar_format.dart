import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class BottomBarFormat extends StatelessWidget {
  final int selectedIndex;
  const BottomBarFormat({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      // Se quitan todos los paddings de Material 3 que deforman la barra.
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Icono Inicio
          TabIcon(
            context: context,
            index: 0,
            icon: selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            label: "Inicio",
          ),

          // Icono Perfil
          TabIcon(
            context: context,
            index: 1,
            icon: selectedIndex == 1 ? Icons.person : Icons.person_outlined,
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  Widget TabIcon({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        if (index != selectedIndex) {
          Navigator.pushReplacementNamed(
            context,
            index == 0 ? AppRouter.dashboard : AppRouter.profile,
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          Text(label, style: AppText.smallWhite),
        ],
      ),
    );
  }
}
