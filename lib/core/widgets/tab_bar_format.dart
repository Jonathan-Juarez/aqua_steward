import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class TabBarFormat extends StatelessWidget {
  final List<String> titles;
  final int selectedIndex;
  final Color activeColor;
  final ValueChanged<int> onTabSelected;

  const TabBarFormat({
    super.key,
    required this.titles,
    required this.selectedIndex,
    required this.activeColor,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: AppBorder.all8,
      ),
      child: Row(
        children: List.generate(
          titles.length,
          (index) => _TabItem(
            title: titles[index],
            index: index,
            activeColor: activeColor,
            selectedIndex: selectedIndex,
            onTabSelected: onTabSelected,
          ),
        ),
      ),
    );
  }
}

// Widget privado auxiliar para cada botón individual
class _TabItem extends StatelessWidget {
  final String title;
  final int index;
  final Color activeColor;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const _TabItem({
    required this.title,
    required this.index,
    required this.activeColor,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: AppBorder.all8,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: isSelected
                ? AppText.bodyWhite
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
