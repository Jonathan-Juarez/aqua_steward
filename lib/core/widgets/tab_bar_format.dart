import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class TabBarFormat extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color activeColor;

  const TabBarFormat({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Color cuando está desactivado (es toda la barra, pero encima se coloca otro para el activado).
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: AppBorder.all8,
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) => _TabItem(
            label: labels[index],
            index: index,
            selectedIndex: selectedIndex,
            onTabSelected: onTabSelected,
            activeColor: activeColor,
          ),
        ),
      ),
    );
  }
}

// Widget privado auxiliar para cada botón individual
class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Color activeColor;

  const _TabItem({
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: AppBorder.all8,
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: AppBorder.all8,
          ),
          alignment: Alignment.center,
          child: TextFormat(
            text: label,
            context: context,
            type: isSelected ? "bodyWhite" : "bodySecondary",
          ),
        ),
      ),
    );
  }
}
