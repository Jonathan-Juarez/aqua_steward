import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_breakpoint.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/widgets/badge_format.dart';
import 'package:flutter/material.dart';

// Elemento individual para la barra de navegación inferior.
class BottomBarItem {
  final Widget icon;
  final Widget? selectedIcon;
  final String label;
  final int? badgeCount;

  const BottomBarItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount,
  });
}

// Barra de navegación inferior flotante tipo cápsula.
class BottomBarFormat extends StatelessWidget {
  final ValueChanged<int>? onPressed;
  final int selectedIndex;
  final List<BottomBarItem> items;

  const BottomBarFormat({
    super.key,
    this.onPressed,
    this.selectedIndex = 0,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = AppBreakpoint.isSmallMobile(context);
    final horizontalMargin = isSmall ? 8.0 : 16.0;

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          left: horizontalMargin,
          right: horizontalMargin,
        ),
        height: MediaQuery.textScalerOf(context).scale(60),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarTheme.color,
          borderRadius: AppBorder.all8,
        ),
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++)
              Expanded(
                child: _TabItem(
                  index: i,
                  item: items[i],
                  isSelected: selectedIndex == i,
                  onPressed: onPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Widget interno para cada pestaña con indicador interactivo.
class _TabItem extends StatelessWidget {
  final int index;
  final BottomBarItem item;
  final bool isSelected;
  final ValueChanged<int>? onPressed;

  const _TabItem({
    required this.index,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Material(
        color: isSelected
            ? AppColor.background.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: AppBorder.all8,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: AppBorder.all8,
          onTap: () {
            if (!isSelected && onPressed != null) {
              onPressed!(index);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColor.white : AppColor.whiteSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final iconWidget =
        isSelected ? (item.selectedIcon ?? item.icon) : item.icon;
    return BadgeFormat(
      unreadCount: item.badgeCount ?? 0,
      child: iconWidget,
    );
  }
}
