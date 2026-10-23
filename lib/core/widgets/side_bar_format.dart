import 'package:aqua_steward/core/theme/app_border.dart';
import 'package:aqua_steward/core/theme/app_breakpoint.dart';
import 'package:aqua_steward/core/theme/app_color.dart';
import 'package:aqua_steward/core/theme/app_padding.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/widgets/badge_format.dart';
import 'package:aqua_steward/core/widgets/bottom_bar_format.dart';
import 'package:flutter/material.dart';

// Barra de navegación lateral para tablets y pantallas grandes.
class SideBarFormat extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onPressed;
  final List<BottomBarItem> items;
  final Widget? header;
  final Widget? footer;

  const SideBarFormat({
    super.key,
    required this.selectedIndex,
    required this.onPressed,
    required this.items,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoint.isDesktop(context);
    final barWidth = isDesktop ? 96.0 : 80.0;
    final backgroundColor = Theme.of(context).bottomAppBarTheme.color;

    return SafeArea(
      right: false,
      child: Container(
        width: barWidth,
        margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppBorder.all8,
        ),
        child: Column(
          children: [
            if (header != null) ...[
              Padding(padding: AppPadding.symmetric8_0, child: header!),
            ] else ...[
              AppSizedBox.height12,
            ],
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => AppSizedBox.height8,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = selectedIndex == index;

                  return _SideBarItem(
                    index: index,
                    item: item,
                    isSelected: isSelected,
                    onPressed: onPressed,
                  );
                },
              ),
            ),
            if (footer != null) ...[
              Padding(padding: AppPadding.symmetric8_0, child: footer!),
            ] else ...[
              AppSizedBox.height12,
            ],
          ],
        ),
      ),
    );
  }
}

// Widget de item individual para la barra lateral con respuesta táctil.
class _SideBarItem extends StatelessWidget {
  final int index;
  final BottomBarItem item;
  final bool isSelected;
  final ValueChanged<int>? onPressed;

  const _SideBarItem({
    required this.index,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.symmetric0_8,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(),
                AppSizedBox.height8,
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColor.white
                        : AppColor.whiteSecondary,
                  ),
                ),
              ],
            ),
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
